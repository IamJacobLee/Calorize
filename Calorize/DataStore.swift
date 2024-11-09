//
//  DataStore.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI
struct Log: Identifiable {
    var id = UUID()
    var name: String
    var calories: Int
    var date: Date
}

struct RecentsView: View {
    @State private var  Logs: [Log] = [
        Log(name: "Apple", calories: 20, date: .now),
        Log(name: "Potatoes", calories: 50, date: .now)
    ]
    var body: some View {
        NavigationStack {
            List(Logs) { Log in
                Text(Log.name)
            }
            .navigationTitle("Recents")
        }
        
    }
}
#Preview {
    RecentsView()
}
