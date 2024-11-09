//
//  CalorizeApp.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//

import SwiftUI

@main
struct CalorizeApp: App {
    @State var logManager = LogManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(logManager)
        }
    }
}
