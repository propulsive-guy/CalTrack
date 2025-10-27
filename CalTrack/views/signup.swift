import SwiftUI

struct SignupView: View {
    @AppStorage("name") private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var login: Bool = false
    
    // MARK: - SIGNUP FUNCTION TO REGISTER USER AND STORE CONTENT IN DATABASE
    func sginup () {
        
        guard let url = URL(string: "http://192.168.29.198:5000/signup") else {return}
        
        
        let user = [
            
            "username" : username,
            "email" : email,
            "password" : password
           
            
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: user ) else {return}
           
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request){ data , response , error in
            
            if let error = error{
                
                print("error :",error)
                return
            }
            
            guard let data = data else {return}
            
            if let responseJson = try? JSONSerialization.jsonObject(with: data) as? [String:Any]{
                
                print("response:", responseJson)
                
                DispatchQueue.main.async{
                    login = true
                    print("signup done")
                }
                
            }
            
            
            
            
        }.resume()
        
        
        
    }
    
    var body: some View {
        Group {
            if login {
                Loginview()
            } else {
                ZStack {
                    VStack(spacing: 20) {
                        // Title
                        Text("Sign Up")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color.green)
                        
                        // Username
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        
                        // Email
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        // Password
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        
                        // Confirm Password
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        
                        // Signup Button
                        Button(action: {
                            sginup()
                            print("idhar koi problem nhi hai bhai ")
                            
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.7))
                                .cornerRadius(20)
                        }
                        
                        // Already have an account? Login link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Button(action: {
                                login = true
                            print("bhaitad")// Navigate to login
                            }) {
                                Text("Login")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(30)
                    .frame(width: 350, height: 600)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                }
            }
        } 
    }
}

#Preview {
    SignupView()
}

