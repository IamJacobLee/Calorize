//
//  FoodItem+Sample.swift
//  Calorize
//
//  Created by Timothy Laurentius on 18/11/24.
//
import Foundation
extension FoodItem{
    static let sampleItems: [FoodItem] = [
        FoodItem(name: "Apple", calories: 100, date: Date.distantPast),
        FoodItem(name: "Banana", calories: 80, date: Date.now.addingTimeInterval(-86400)),
        FoodItem(name: "Orange", calories: 60, date: Date.now.addingTimeInterval(-172800)),
        FoodItem(name: "Blueberry", calories: 20, date: Date.now)
    ]
}
