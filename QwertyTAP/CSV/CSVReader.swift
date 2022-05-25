//
//  CSVReader.swift
//  QwertyTAP
//
//  Created by Shahar Biran on 25/05/2021.
//

import Foundation

class CSVReader {
    static func readCSV(_ filename:String) -> String? {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            return nil
        }
        do {
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            return CSVReader.cleanedCSV(contents)
        } catch {
            return nil
        }
        
    }
    
    static private func cleanedCSV(_ contents:String) -> String {
        return contents.replacingOccurrences(of: "\r", with: "\n").replacingOccurrences(of: "\n\n", with: "\n")
    }
}
