//
//  Untitled.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI

struct LogDetailView: View {
    @State private var Logs = Log (name: "Carrot", calories: 30, date: .now)
    
    var body: some View {
        Form {
            TextField("Name", text: $Logs.name)
            TextField("Calories", value: $Logs.calories, format: .number)
        }
    }
}
