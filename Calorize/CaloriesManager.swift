import Foundation
import Observation

@Observable class CaloriesManager {
    var totalSavedCalories: Int = 0 {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "totalCalories.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedTotalCalories = try? jsonEncoder.encode(totalSavedCalories)
        try? encodedTotalCalories?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
                
        if let retrievedTotalCaloriesData = try? Data(contentsOf: archiveURL),
           let totalCaloriesDecoded = try? jsonDecoder.decode(Int.self, from: retrievedTotalCaloriesData) {
            totalSavedCalories = totalCaloriesDecoded
        }
    }
}
