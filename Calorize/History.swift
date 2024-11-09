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

struct AverageCalories: Identifiable {
    var id = UUID()
    var day: String
    var calories: Int
}
@Observable
class ViewModel {
    // 3.
    var data: [AverageCalories] = [
        AverageCalories(day: "Monday", calories: 100),
        AverageCalories(day: "Tuesday", calories: 120),
        AverageCalories(day: "Wednesday", calories: 140),
        AverageCalories(day: "Thursday", calories: 160),
        AverageCalories(day: "Friday", calories: 180),
        AverageCalories(day: "Saturday", calories: 210),
        AverageCalories(day: "Sunday", calories: 240),
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
                x: .value("Month", $0.day),
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
