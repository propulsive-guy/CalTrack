import SwiftUI

struct DashboardView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Main content
            TabView(selection: $selectedTab) {
                // 1️⃣ Stats Screen
                StatsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Stats")
                    }
                    .tag(1)
                
                // 2️⃣ Camera Screen (Center tab)
                CameraView()
                    .tabItem {
                        VStack {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(5)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(y: -10) // Lift camera icon above tab bar
                        }
                    }
                    .tag(2)
                
                // 3️⃣ User Profile Screen
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("User")
                    }
                    .tag(0)
            }
            .accentColor(.green) // Selected tab color
        }
    }
}

// MARK: - Sample Screens




  


// Preview
#Preview {
    DashboardView()
}

