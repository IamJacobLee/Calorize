import Foundation
import Observation

@Observable class FoodItemManager {
    var foodItems: [FoodItem] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "foodItems.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedFoodItems = try? jsonEncoder.encode(foodItems)
        try? encodedFoodItems?.write(to: archiveURL, options: .noFileProtection)
    }
//    func loadSampleData() {
//        foodItems = FoodItem.sampleItems
//    }
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
                
        if let retrievedFoodItemData = try? Data(contentsOf: archiveURL),
           let foodItemsDecoded = try? jsonDecoder.decode([FoodItem].self, from: retrievedFoodItemData) {
            foodItems = foodItemsDecoded
        }
    }
}
