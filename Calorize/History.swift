import Foundation
import SwiftUI
import Charts
import Observation
struct HistoryView: View {
    @State private var foodItemManager = FoodItemManager()
    var body: some View{
        @Bindable var foodItemManager = foodItemManager
        NavigationStack {
            List($foodItemManager.foodItems) { $FoodItem in
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
}


#Preview {
    HistoryView()
}
