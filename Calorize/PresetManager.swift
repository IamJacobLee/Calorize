import Foundation
import Observation

@Observable class PresetManager {
    var presets: [PresetFoodItem] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "presets.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedPresets = try? jsonEncoder.encode(presets)
        try? encodedPresets?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
                
        if let retrievedPresetData = try? Data(contentsOf: archiveURL),
           let presetsDecoded = try? jsonDecoder.decode([PresetFoodItem].self, from: retrievedPresetData) {
            presets = presetsDecoded
        }
    }
}
