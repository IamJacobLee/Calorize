//
//  DataStore.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI
import Charts
import Observation
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
        Chart(dataCollection.data) { data in
            // 2.
            LineMark(
                // 3.
                x: .value("Month", data.name),
                y: .value("Total", data.calories)
            )
        }
        .padding()
        .frame(height: 200)
    }
}
#Preview {
    ChartView(dataCollection: ViewModel())
}
