//
//  Untitled.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI
struct LogDetailView: View {
    @Binding var item: FoodItem
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $item.name)
                TextField("Calories", value: $item.calories, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
            }
          
         
        }
    }
}

