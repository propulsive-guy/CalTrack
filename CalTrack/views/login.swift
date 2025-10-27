import SwiftUI

struct Loginview: View {
    
    @AppStorage("name") private var username = ""
    @State private var password = ""
    @State private var signup: Bool = false // State to navigate to signup
    @State private var dashboard : Bool=false
    
    
    func login(){
        
        print("login func invoked")
        
        guard let url = URL(string: "http://192.168.29.198:5000/login") else {return}
        
        let user=[
            
            "username":username,
            "password":password
            
            
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: user) else{
            return}
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        
        URLSession.shared.dataTask(with: request){ data , resposne , error in
            
            if let error = error {
                print("network error", error)
            }
            
            guard let data = data else{
                
                return
            }
            
            if let responsejson =  try? JSONSerialization.jsonObject(with: data) as? [String:Any]{
                
                print("response",responsejson)
                
                DispatchQueue.main.async{
                    
                    dashboard=true
                    
                }
                
            }
            
            
            
        }.resume()
        
    }
    
    
    var body: some View {
        Group {
            if signup {
              SignupView()// Navigate to SignupView
            }else if dashboard{
                DashboardView()
                
            }
            
            
            else {
                ZStack {
                    VStack(spacing: 30) {
                        Text("Login")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(Color.green)
                        
                        // Username
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        
                        // Password
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        
                        // Login Button
                        Button(action: {
                            login()
                            print("Login tapped")
                         
                        }) {
                            Text("Login")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(20)
                        }
                        
                        // New User? Signup
                        HStack {
                            Text("New user?")
                                .foregroundColor(.gray)
                            Button(action: {
                                signup = true // Navigate to SignupView
                            }) {
                                Text("Sign Up")
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, 10)
                        
                    }
                }
                .padding(30)
                .frame(width: 350, height: 550)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }
        } // End Group
    }
}

#Preview {
    Loginview()
}

