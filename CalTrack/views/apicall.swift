//
//  apicall.swift
//  CalTrack
//
//  Created by Priyanshu behere on 18/10/25.
//

import SwiftUI




struct ApiView : View {
    
    @State var name : String = "loading ..."
    var body: some View {
        
        VStack(spacing: 10){
            
            Text("Api testing random name generator").font(.title)
            
            Text(name).bold()
            
            Button("get name"){
                
                getname()
            }.background(Color.blue.opacity(0.1))
            
        }
        
        .onAppear(){
            getname()
        }
        
    }
    
    func getname(){
        
        guard let url = URL (string: "http://127.0.0.1:5000/random_name") else { return }
        
        URLSession.shared.dataTask(with: url){ data ,response , error in
            if let data = data{
                if let json = try?  JSONSerialization.jsonObject(with: data) as? [String:String], let name = json["name"]{
                    
                    DispatchQueue.main.async{ self.name = name}
                }
            } else if let error = error {
                print("error \(error.localizedDescription)")
            }
            
        }.resume()
        
        
    }
}



#Preview {
    ApiView()
}
