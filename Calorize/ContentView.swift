import SwiftUI

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Int
    var date: Date
}

struct PresetFoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Int
    var emoji: String
    var color: FoodItemColor
    
    var uiColor: Color {
        color.color
    }
}

struct ContentView: View {
    @State private var isPresentingLogView = false
    @State private var selectedPreset: PresetFoodItem = PresetFoodItem(name: "", calories: 0, emoji: "", color: .yellow)
    
    @State private var caloriesManager = CaloriesManager()
    @State private var caloriesGoalManager = CaloriesGoalManager()
    @State private var foodItemManager = FoodItemManager()
    @State private var presetManager = PresetManager()
    @State private var showingGoalAlert = false
    @State private var isPresentingPresetLogView = false
    
    var body: some View {
        TabView {
            VStack {
                CircularProgressBar(progress: CGFloat(caloriesManager.totalSavedCalories) / CGFloat(caloriesGoalManager.calorieGoal))
                    .frame(width: 150, height: 150)
                    .padding(.top)
                
                Text("\(caloriesManager.totalSavedCalories) of \(caloriesGoalManager.calorieGoal) calories")
                    .font(.title)
                    .padding(.top)
                
                Button("Edit") {
                    showingGoalAlert.toggle()
                }
                .alert("Calorie Goal", isPresented: $showingGoalAlert) {
                    TextField(
                        "Calories",
                        value: Binding(get: { caloriesGoalManager.calorieGoal }, set: {
                            if $0 > 0 {
                                caloriesGoalManager.calorieGoal = $0
                            }
                        }),
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
                    
                    ForEach(presetManager.presets) { preset in
                        Button {
                            isPresentingPresetLogView = true
                            selectedPreset = preset
                        } label: {
                            FoodIcon(icon: preset.emoji, color: preset.uiColor)
                        }
                    }
                }
                .padding(.vertical, 30)
                
                Spacer()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .sheet(isPresented: $isPresentingLogView) {
                LogFoodView()
                    .environment(caloriesManager)
                    .environment(foodItemManager)
                    .environment(presetManager)
            }
            .sheet(isPresented: $isPresentingPresetLogView) {
                LogFoodView(foodName: selectedPreset.name, calories: selectedPreset.calories, isPreset: false, selectedEmoji: selectedPreset.emoji, selectedColor: selectedPreset.color)
                    .environment(caloriesManager)
                    .environment(foodItemManager)
                    .environment(presetManager)
            }
            
            // History Tab
            HistoryView()
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
            
            ViewThatFits {
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()
                
                Text("\(Int(progress * 100))%")
                    .font(.title)
                    .bold()
                
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .bold()
            }
        }
    }
}

struct FoodIcon: View {
    var icon: String
    var color: Color = Color.gray.opacity(0.2)
    
    var body: some View {
        Text(icon)
            .font(.largeTitle)
            .padding()
            .background(color)
            .clipShape(Circle())
    }
}

enum FoodItemColor: Codable, CaseIterable {
    case red, orange, yellow, green, blue, purple, pink
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        }
    }
}

struct LogFoodView: View {
    @Environment(CaloriesManager.self) var caloriesManager
    @Environment(FoodItemManager.self) var foodItemManager
    @Environment(PresetManager.self) var presetManager
    @Environment(\.dismiss) var dismiss
    
    @State var foodName = ""
    @State var calories = 0
    @State var isPreset = false
    @State var selectedEmoji = "🍔"
    @State var selectedColor: FoodItemColor = .red
    
    let emojis = ["🍔", "🍫", "🍕", "🍗", "🍪", "🍎", "🥗"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Log")) {
                    TextField("Name", text: $foodName)
                    TextField("Calories", value: $calories, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Toggle("Save As Preset", isOn: $isPreset)
                    
                    if isPreset {
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
                                ForEach(FoodItemColor.allCases, id: \.self) { color in
                                    Circle()
                                        .fill(color.color)
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
                }
                
                Section {
                    Button("Log") {
                        if isPreset {
                            presetManager.presets.append(PresetFoodItem(name: foodName, calories: calories, emoji: selectedEmoji, color: selectedColor))
                        }
                        foodItemManager.foodItems.append(FoodItem(name: foodName, calories: calories, date: Date()))
                        caloriesManager.totalSavedCalories += calories
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

#Preview {
    ContentView()
}
