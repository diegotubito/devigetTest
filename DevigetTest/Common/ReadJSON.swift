//
//  ReadJSON.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Foundation

class ReadJSON {
    
    static let shared = ReadJSON()
    
    enum readJSONError: Error {
        case unknown
    }
    
    static func jsonArray(json: [String: Any]) -> [[String: Any]] {
        var result = [[String : Any]]()
        
        for (_, value) in json {
            if let aux = value as? [String : Any] {
                result.append(aux)
            }
        }
        
        return result
    }
    
    static func readJSONFromFile(fileName: String) throws -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
                throw error
            }
        }
        return json
    }
}

