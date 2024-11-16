import Foundation
import SwiftUI
import Charts
import Observation
struct HistoryView: View {
    @Environment(FoodItemManager.self) private var foodItemManager
    @State private var selectedInterval = 86400.0
    var foodItemArray: [FoodItem] {
        var tempArray: [FoodItem] = []
        var currentTotalCal = 0
        for item in foodItemManager.foodItems.sorted(by: { $0.date < $1.date }) {
            if Date().timeIntervalSince(item.date)<selectedInterval{
                currentTotalCal += item.calories
                tempArray.append(FoodItem(name: "", calories: currentTotalCal, date: item.date))
            }
        }
        print(tempArray.map({ $0.calories }))
        return tempArray
    }
    var body: some View{
        @Bindable var foodItemManager = foodItemManager
        NavigationStack {
            List {
                if foodItemManager.foodItems.count>1{
                    Section {
                        Picker("Interval", selection: $selectedInterval) {
                            Text("Day").tag(86400.0)
                            Text("Week").tag(604800.0)
                            Text("Month").tag(2592000.0)
                        }
                        
                        .pickerStyle(.segmented)
                        Divider()
                        if foodItemArray.isEmpty{
                            Text("No data to display!")
                        }
                        else {
                            Chart(foodItemArray) { item in
                                // 2.
                                LineMark(
                                    // 3.
                                    x: .value("Month", item.date),
                                    y: .value("Total", item.calories)
                                )
                            }
                        }
                    }
                }else{
                    Text("Log more food items to see a chart!")
                }
                Section {
                    ForEach($foodItemManager.foodItems, editActions: [.all]) { $FoodItem in
                        NavigationLink{
                            LogDetailView(item: $FoodItem)
                        }label:{
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(FoodItem.name)
                                    HStack{
                                        Text(FoodItem.date, style: .date)
                                        Text(FoodItem.date, style: .time)
                                    }
                                    .font(.subheadline)
                                    .opacity(0.5)
                                }
                                Spacer()
                                Text("\(FoodItem.calories) Cal")
                                
                            }
                        }
                    }
                }
            }
            
            
            .navigationTitle("History")
            
            
        }
    }
}


#Preview {
    HistoryView()
}
