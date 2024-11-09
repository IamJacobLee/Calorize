import Foundation
import SwiftUI
import Charts
import Observation
struct HistoryView: View {
    var body: some View{
            Text("History")
                .font(.title)
                .padding()
                .bold()
    }
}

struct AverageCalories: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Int
}
@Observable
class ViewModel {
    // 3.
    var data: [AverageCalories] = [
        AverageCalories(name: "Monday", calories: 100),
        AverageCalories(name: "Tuesday", calories: 120),
        AverageCalories(name: "Wednesday", calories: 140),
        AverageCalories(name: "Thursday", calories: 160),
        AverageCalories(name: "Friday", calories: 180),
        AverageCalories(name: "Saturday", calories: 210),
        AverageCalories(name: "Sunday", calories: 240),
    ]
}
struct ChartView: View {
    
    var dataCollection: ViewModel
    
    var body: some View {
        
        // 1.
        Chart(dataCollection.data) {
            // 2.
            LineMark(
                // 3.
                x: .value("Month", $0.name),
                y: .value("Total", $0.calories)
            )
        }
        .padding()
        .frame(height: 200)
    }
}
#Preview {
    HistoryView()
}
