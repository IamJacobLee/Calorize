import SwiftUI
import Combine

struct FoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var calories: Int
    var date: Date
}

struct PresetFoodItem: Identifiable, Codable, Equatable {
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
    @State private var selectedPreset: PresetFoodItem?
    
    @AppStorage("lastLogin") private var lastLoginDate: Date = .distantPast
    var currentTotal: Int {
        var currentTotalCal: Int = 0
        for item in foodItemManager.foodItems.sorted(by: { $0.date < $1.date }) {
            if Date().timeIntervalSince(item.date)<86400{
                currentTotalCal += item.calories
            }
        }
        return currentTotalCal
    }
    @State private var caloriesManager = CaloriesManager()
    @State private var caloriesGoalManager = CaloriesGoalManager()
    @State private var foodItemManager = FoodItemManager()
    @State private var presetManager = PresetManager()
    @State private var showingGoalAlert = false
    @State private var cancellable: AnyCancellable? // To store the timer

    var body: some View {
        TabView {
            VStack {
                CircularProgressBar(progress: CGFloat(currentTotal) / CGFloat(caloriesGoalManager.calorieGoal))
                    .frame(width: 150, height: 150)
                    .padding(.top)
                
                Text("\(currentTotal) of \(caloriesGoalManager.calorieGoal) calories today")
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
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 20) {
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
                                selectedPreset = preset
                            } label: {
                                FoodIcon(icon: preset.emoji, color: preset.uiColor)
                                    
                            }
                        }
                    }
                    .padding(30)
                }
                
                Spacer()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .sheet(isPresented: $isPresentingLogView) {
                LogFoodView(openedFromPresetItem: false)
                    .environment(caloriesManager)
                    .environment(foodItemManager)
                    .environment(presetManager)
            }
            .sheet(item: $selectedPreset) { selectedPreset in
                LogFoodView(foodName: selectedPreset.name, calories: selectedPreset.calories, isPreset: false, selectedEmoji: selectedPreset.emoji, selectedColor: selectedPreset.color, openedFromPresetItem: true)
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
        .onAppear(perform: startMidnightTimer)
        .environment(foodItemManager)
    }
    
    private func startMidnightTimer() {
        if !Calendar.current.isDateInToday(lastLoginDate) {
            caloriesManager.totalSavedCalories = 0
            lastLoginDate = .now
        }
        // Create a timer that publishes every 60 seconds and checks if it's midnight
        
        let tomorrowDate = Calendar.current.startOfDay(for: Date.now.addingTimeInterval(86400))
        
        let secondsToMidnight = abs(Date.now.timeIntervalSince(tomorrowDate))
        
        Timer.scheduledTimer(withTimeInterval: secondsToMidnight, repeats: false) { _ in
            caloriesManager.totalSavedCalories = 0
            lastLoginDate = .now
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
    @State var openedFromPresetItem: Bool
    
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
                    if !openedFromPresetItem {
                        Toggle("Save As Preset", isOn: $isPreset)
                    }
                    
                    if isPreset && !openedFromPresetItem{
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
                        foodItemManager.foodItems.insert(FoodItem(name: foodName, calories: calories, date: Date()), at: 0)
                        caloriesManager.totalSavedCalories += calories
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    if openedFromPresetItem{
                        Button("Delete this preset", role: .destructive){
                            presetManager.presets.remove(at: presetManager.presets.firstIndex(where: {$0.name == foodName})!)
                            dismiss()
                        }
                    }
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
