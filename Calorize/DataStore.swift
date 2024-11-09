//
//  DataStore.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI

struct NewLog: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Int
}

