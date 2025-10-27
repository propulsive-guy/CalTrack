import SwiftUI

struct ProfileView: View {
    
    @State var height : String = ""
    @State var weight : String = ""
    @State var goal : String = ""
    @AppStorage("name") var user: String = ""
    @AppStorage("caloriegoal") var calorie : Double = 0
    @State var gender : String = "Male"
    @State var activity : String = "Moderate"
    @State var age : String=""
    @State var alertset : Bool = false
    let activities = ["Sedentary", "Light", "Moderate", "Active", "Very Active"]
    @State var login : Bool = false
    
    // MARK: - Calorie Calculation Function
    func calcal(height: String,
                weight: String,
                age: String,
                gender: String,
                activity: String,
                goal: String) -> Double? {
        
        guard let weightVal = Double(weight),
              let heightFeet = Double(height),
              let ageVal = Double(age) else { return nil }
        
        let heightMeters = heightFeet * 12 * 0.0254
        let heightCm = heightMeters * 100
        
        var bmr: Double
        if gender.lowercased() == "male" {
            bmr = 10 * weightVal + 6.25 * heightCm - 5 * ageVal + 5
        } else {
            bmr = 10 * weightVal + 6.25 * heightCm - 5 * ageVal - 161
        }
        
        let activityFactor: Double
        switch activity.lowercased() {
        case "sedentary": activityFactor = 1.2
        case "light": activityFactor = 1.375
        case "moderate": activityFactor = 1.55
        case "active": activityFactor = 1.725
        case "very active": activityFactor = 1.9
        default: activityFactor = 1.55
        }
        
        var tdee = bmr * activityFactor
        
        switch goal.lowercased() {
        case "weight loss": tdee -= 500
        case "muscle gain": tdee += 400
        default: break
        }
        
        return tdee
    }
    
    var body: some View {
        
        if login {
            Loginview()
        }
        else{
            NavigationStack {
                
                VStack(spacing: 30) {
                    
                    // MARK: Greeting & User
                    HStack {
                        Text("Hi, \(user)").bold().font(.title2)
                        Spacer()
                        Image(systemName:"person.fill")
                    }
                    .padding(.horizontal)
                    
                    // MARK: Display Daily Calorie Goal
                    VStack(spacing: 10) {
                        Text("Daily Calorie Goal")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(Int(calorie)) kcal")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    .frame(maxWidth: .infinity,maxHeight: 200)
                    
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top,60)
                    
                    
                    
                    // MARK: Set Goal Button / Navigation
                    NavigationLink(destination: bmiView) {
                        Text("Set / Update Goal")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                    Button("Logout"){
                        login = true
                    }.frame(width: 90, height: 50).background(Color.gray.opacity(0.2)).cornerRadius(200).padding(.bottom,100)
                }
                .padding(.top)
            }}
    }
    
    // MARK: BMI / Goal Input View
    var bmiView: some View {
        VStack(spacing: 25) {
            
            Text("Set Your Goal").font(.title).bold()
            
            // Height
            TextField("Height (Feet)", text: $height)
                .keyboardType(.decimalPad)
                .padding()
                .frame(height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            // Age
            TextField("Age (Years)", text: $age)
                .keyboardType(.numberPad)
                .padding()
                .frame(height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            // Weight
            TextField("Weight (Kg)", text: $weight)
                .keyboardType(.decimalPad)
                .padding()
                .frame(height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            // Goal Picker
            VStack(alignment: .leading) {
                Text("Goal").bold()
                Picker("Select Goal", selection: $goal) {
                    Text("Weight Loss").tag("weight loss")
                    Text("Muscle Gain").tag("muscle gain")
                    Text("Maintain").tag("maintain")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Activity & Gender
            HStack(spacing: 15) {
                
                VStack(alignment: .leading) {
                    Text("Activity").bold()
                    Picker("Select Activity", selection: $activity) {
                        ForEach(activities, id: \.self) { a in
                            Text(a).tag(a)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    Text("Gender").bold()
                    Picker("Select Gender", selection: $gender) {
                        Text("Male").tag("male")
                        Text("Female").tag("female")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            // MARK: Set Button
            Button(action: {
                calorie = calcal(height: height, weight: weight, age: age, gender: gender, activity: activity, goal: goal) ?? 0
               alertset = true
            }) {
                Text("Set Goal")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            Spacer()
        }.alert("Goal Set", isPresented: $alertset) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your calorie goal is \(Int(calorie)) kcal")
        }
        .padding()
    
        .navigationTitle("Set Goal")
    }
}

#Preview {
    ProfileView()
}

