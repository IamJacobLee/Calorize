//
//  ContentView.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var logManager = LogManager()
    var body: some View {
        @Bindable var logManager = logManager
        VStack {
          
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeView()
                }
                Tab("History", systemImage: "clock.fill") {
                    HistoryView()
                }
            }
            
        }
    }
    
    
}
#Preview {
    ContentView()
}

