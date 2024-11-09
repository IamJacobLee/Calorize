//
//  Untitled.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//
import SwiftUI

struct HomeView: View {
    @State private var showLogsheet = false
    var body: some View {
            Gauge(value:0.5) {
                Text("Yay")
                    .font(.largeTitle)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .scaleEffect(3)

            Text("Home")
            Button("Log") {
                showLogsheet.toggle()
            }
            .sheet(isPresented: $showLogsheet){
                Logsheet()
                    .presentationDetents([.medium])
        }
    }
}

struct Logsheet: View {
    @State var name: String = ""
    @State var calories: Int = 0
    @State var isPreset = false
    @State var emoji: String = ""
    @State var tagColor: Color = .red
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField(
                    "Name",
                    text: $name
                )
                TextField(
                    "Calories",
                    value: $calories,
                    formatter: NumberFormatter()
                )
            }
            Section {
                Toggle("Save As Preset", isOn: $isPreset)
                if isPreset == true {
                    TextField(
                        "Emoji",
                        text: $emoji
                    
                    )
                    .onChange(of: emoji) {
                        while emoji.count > 1 {
                            emoji.removeLast()
                        }
                    }
                    ColorPicker("Tag Color", selection: $tagColor)
                }
            }
            
            
            Section {
                Button("Save") {
                 
                    dismiss()
                }
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                
            }
            
        }
        
    }
}
#Preview {
    HomeView()
}
