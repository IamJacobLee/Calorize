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
        AverageCalories(name: "Mon", calories: 1500),
        AverageCalories(name: "Tue", calories: 1700),
        AverageCalories(name: "Wed", calories: 1400),
        AverageCalories(name: "Thu", calories: 1600),
        AverageCalories(name: "Fri", calories: 1800),
        AverageCalories(name: "Sat", calories: 2100),
        AverageCalories(name: "Sun", calories: 2400),
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
