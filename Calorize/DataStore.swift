//
//  DataStore.swift
//  Calorize
//
//  Created by Timothy Laurentius on 9/11/24.
//

import SwiftUI

struct Log: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var calories: Int
    var date: Date
}

@Observable class LogManager {
    var logData: [Log] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "logDatas.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedLogs = try? jsonEncoder.encode(logData)
        try? encodedLogs?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
                
        if let retrievedLogData = try? Data(contentsOf: archiveURL),
           let logDatasDecoded = try? jsonDecoder.decode([Log].self, from: retrievedLogData) {
            logData = logDatasDecoded
        }
    }
}
