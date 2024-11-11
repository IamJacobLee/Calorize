//
//  ContentView.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//

import SwiftUI

struct FoodItem: Identifiable {
    let id = UUID()
    var name: String
    var calories: Int
    var emoji: String
    var color: Color
}

struct ContentView: View {
    @State private var isPresentingLogView = false
    @State private var totalCalories = 500
    @State private var calorieGoal = 2000
    @State private var foodItems: [FoodItem] = []
    @State private var selectedFoodItem: FoodItem? = nil
    @State private var showingGoalAlert = false
    var body: some View {
        TabView {
            VStack {
                CircularProgressBar(progress: CGFloat(totalCalories) / CGFloat(calorieGoal))
                    .frame(width: 150, height: 150)
                    .padding(.top)
                
                Text("\(totalCalories) of \(calorieGoal) calories")
                    .font(.title)
                    .padding(.top)
                Button("Edit") {
                           showingGoalAlert.toggle()
                       }
                .alert("Calorie Goal", isPresented: $showingGoalAlert)
                {
                    TextField(
                        "Calories",
                        value: $calorieGoal,
                        formatter: NumberFormatter()
                    )
                }

             
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                    Button(action: {
                        isPresentingLogView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    FoodIcon(icon: "🍔")
                    FoodIcon(icon: "🍫")
                    FoodIcon(icon: "🍕")
                    FoodIcon(icon: "🍗")
                    FoodIcon(icon: "🍪")
                    
                    ForEach(foodItems) { item in
                        Button(action: {
                            selectedFoodItem = item
                        }) {
                            Text(item.emoji)
                                .font(.largeTitle)
                                .padding()
                                .background(item.color.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.vertical, 30)
                .sheet(item: $selectedFoodItem) { item in
                    FoodDetailView(foodItem: item)
                }
                
                Spacer()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .sheet(isPresented: $isPresentingLogView) {
                LogFoodView(totalCalories: $totalCalories, foodItems: $foodItems)
            }
            
            Text("History")
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
    }
}

struct CircularProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: -90))
            
            Text("\(Int(progress * 100))%")
                .font(.largeTitle)
                .bold()
        }
    }
}

struct FoodIcon: View {
    var icon: String
    
    var body: some View {
        Text(icon)
            .font(.largeTitle)
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
    }
}

struct LogFoodView: View {
    @Binding var totalCalories: Int
    @Binding var foodItems: [FoodItem]
    @Environment(\.dismiss) var dismiss
    
    @State private var foodName = ""
    @State private var calories = ""
    @State private var isPreset = false
    @State private var selectedEmoji = "🍔"
    @State private var selectedColor: Color = .red
    
    let emojis = ["🍔", "🍫", "🍕", "🍗", "🍪", "🍎", "🥗"]
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Log")) {
                    TextField("Name", text: $foodName)
                    TextField("Calories", text: $calories)
                        .keyboardType(.numberPad)
                    
                    Toggle("Save As Preset", isOn: $isPreset)
                    
                    // Emoji Picker
                    VStack(alignment: .leading) {
                        Text("Emoji")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(emojis, id: \.self) { emoji in
                                    Text(emoji)
                                        .font(.largeTitle)
                                        .padding()
                                        .background(selectedEmoji == emoji ? Color.gray.opacity(0.2) : Color.clear)
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            selectedEmoji = emoji
                                        }
                                }
                            }
                        }
                    }
                                        VStack(alignment: .leading) {
                        Text("Color")
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                }
                
                Section {
                    Button("Save") {
                        if let caloriesToAdd = Int(calories) {
                            totalCalories += caloriesToAdd
                            let newItem = FoodItem(name: foodName, calories: caloriesToAdd, emoji: selectedEmoji, color: selectedColor)
                            foodItems.append(newItem)
                        }
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Log Food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FoodDetailView: View {
    var foodItem: FoodItem
    
    var body: some View {
        VStack {
            Text(foodItem.emoji)
                .font(.system(size: 100))
                .padding()
                .background(foodItem.color.opacity(0.2))
                .clipShape(Circle())
            
            Text(foodItem.name)
                .font(.title)
                .padding(.top, 10)
            
            Text("\(foodItem.calories) calories")
                .font(.headline)
                .padding(.top, 5)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
