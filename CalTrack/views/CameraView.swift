import SwiftUI
import SwiftData

// MARK: - SwiftData Model
@Model
final class Meal {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Int
    var date: Date
    
    init(name: String, calories: Int, date: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.date = date
    }
}

// MARK: - CameraView
struct CameraView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Meal.date, order: .reverse) private var meals: [Meal]
    
    @State private var pickedImage: UIImage? = nil
    @State private var showingPicker = false
    @State private var isProcessing = false
    @State private var latestMeal: Meal? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Capture or Upload Meal")
                    .font(.title2)
                    .bold()
                
                ZStack {
                    if let image = pickedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(12)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                            .cornerRadius(12)
                            .overlay(
                                Text("No Image Selected")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    if isProcessing {
                        ProgressView("Processing...")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
                
                Button("Upload Photo") {
                    showingPicker = true
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showingPicker) {
                    ImagePicker(selectedImage: $pickedImage)
                }
                
                if let meal = latestMeal {
                    VStack {
                        Text("Latest Meal: \(meal.name)")
                        Text("Calories: \(meal.calories)")
                        Text("Time: \(meal.date.formatted(.dateTime.hour().minute()))")
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Divider().padding(.vertical)
                
                Text("Previous Meals")
                    .font(.headline)
                
                List(meals) { meal in
                    VStack(alignment: .leading) {
                        Text(meal.name).bold()
                        Text("Calories: \(meal.calories)")
                        Text(meal.date.formatted(.dateTime.day().month().year().hour().minute()))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .onChange(of: pickedImage) { newImage in
            guard let image = newImage else { return }
            sendImageToFlask(image: image)
        }
    }
    
    // MARK: - Send image to Flask
    // MARK: - Send image to Flask
    func sendImageToFlask(image: UIImage) {
        guard let url = URL(string: "http://192.168.29.198:5000/calorie") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        isProcessing = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isProcessing = false
                
                if let error = error {
                    print("Error:", error)
                    return
                }
                
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Response:", json)
                        
                        // Check if the API call was successful
                        guard let status = json["status"] as? String, status == "success" else {
                            print("API returned non-success status")
                            return
                        }
                        
                        // Extract food name and calories from the response
                        let foodName = json["food_name"] as? String ?? "Unknown Food"
                        let calories = json["calories"] as? Int ?? 0
                        
                        // Create and save the meal
                        let newMeal = Meal(name: foodName, calories: calories)
                        context.insert(newMeal)
                        
                        // Update the latest meal for display
                        latestMeal = newMeal
                        
                        // Save the context
                        do {
                            try context.save()
                            print("Meal saved successfully!")
                        } catch {
                            print("Failed to save meal:", error)
                        }
                    }
                }
            }
        }.resume()
    }


}

// MARK: - UIImagePickerController for Simulator
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary // Works on Mac simulator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = pickedImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    CameraView()
}

