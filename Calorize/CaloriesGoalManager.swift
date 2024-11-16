import Foundation
import Observation

@Observable class CaloriesGoalManager {
    var calorieGoal: Int = 2000 {
        didSet {
            if calorieGoal>0{
                save()
            }
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "calorieGoal.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedcalorieGoals = try? jsonEncoder.encode(calorieGoal)
        try? encodedcalorieGoals?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
                
        if let retrievedcalorieGoalData = try? Data(contentsOf: archiveURL),
           let calorieGoalDecoded = try? jsonDecoder.decode(Int.self, from: retrievedcalorieGoalData) {
            if calorieGoalDecoded > 0 {
                calorieGoal = calorieGoalDecoded
            } else {
                calorieGoal = 2000
            }
        }
    }
}
