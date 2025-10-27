import SwiftUI
import Charts

struct StatsView: View { // Renamed from ContentView
    let items: [FoodItem] = [
        FoodItem(name: "Apple", calories: 95),
        FoodItem(name: "Banana", calories: 105),
        FoodItem(name: "Orange", calories: 62)
    ]
    
    var body: some View {
        VStack {
            Text("Calories Chart")
                .font(.title)
                .bold()
            
            Chart {
                ForEach(items) { item in
                    BarMark(
                        x: .value("Food", item.name),
                        y: .value("Calories", item.calories)
                    )
                    .foregroundStyle(.red.gradient)
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Double
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

