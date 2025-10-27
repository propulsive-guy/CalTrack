//
//  ContentView.swift
//  CalTrack
//
//  Created by Priyanshu behere on 16/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var next : Bool = false
    @State var loadscreen : Bool = false
    var body: some View {
        
        
      
        ZStack{
            
            if(next){
                Loginview()
            }else{
                
                
                
                HStack(spacing: 0) {  Text("Cal")
                        .foregroundColor(Color.titleclr)
                    Text("Track")
                    .foregroundColor(Color.black)}
                
                .font(.system(size: 70, weight: .bold))
                
                .fontWeight(.heavy)
                .foregroundColor(Color.titleclr)
                //.scaleEffect(loadscreen ? 1 : 5) //
                .opacity(loadscreen ? 1 : 0)
                .onAppear{
                    withAnimation(.easeIn(duration: 1)) {
                        loadscreen = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        next = true}
                }
                
            
                
                
            }}}
}
    

    


#Preview {
    ContentView()
        
}
