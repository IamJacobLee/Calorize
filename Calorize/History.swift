import Foundation
import SwiftUI
import Charts
import Observation
struct HistoryView: View {
    @State private var foodItemManager = FoodItemManager()
    @State private var selectedInterval = 86400.0
    var foodItemArray: [FoodItem]{
        var tempArray: [FoodItem] = []
        for i in foodItemManager.foodItems{
            if Date().timeIntervalSince(i.date)<selectedInterval{
                tempArray.append(i)
            }
        }
        return tempArray
    }
    var body: some View{
        @Bindable var foodItemManager = foodItemManager
        NavigationStack {
            List {
                Chart(foodItemArray) { item in
                    // 2.
                    LineMark(
                        // 3.
                        x: .value("Month", item.date),
                        y: .value("Total", item.calories)
                    )
                }
                ForEach($foodItemManager.foodItems) { $FoodItem in
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
            
            
            .navigationTitle("History")
            
            
        }
    }
}


#Preview {
    HistoryView()
}
