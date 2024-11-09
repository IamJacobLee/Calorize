//
//  ContentView.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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

