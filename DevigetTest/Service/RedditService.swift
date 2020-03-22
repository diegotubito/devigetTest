//
//  RedditService.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

enum ServiceError: Error {
    case server_error
    case unknown_error
    case emptyData
    case body_serialization_error
}

protocol RedditServiceProtocol {
    func searchSubreddit(for query: String, completion: @escaping ([String: Any]?, ServiceError?) -> ())
}

class RedditService : RedditServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func searchSubreddit(for query: String, completion: @escaping ([String: Any]?, ServiceError?) -> ()) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: "https://www.reddit.com/\(trimmedQuery.count == 0 ? "" : "r/\(trimmedQuery)").json?limit=\(Constants.Limit.limitNumberOfPost)&after=t3_10omtd/") else {
            preconditionFailure("Failed to construct search URL for query: \(query)")
        }
        session.dataTask(with: url) { [] data, _, error in
            if let error = error {
                completion(nil, error as? ServiceError)
            }
            else {
                do {
                    let data = data ?? Data()
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    completion(json, nil)
                }
                catch {
                    completion(nil, error as? ServiceError)
                }
            }
        }.resume()
    }
    
    func getPostFromJSONFile(result: ([Post]?, Error?) -> ()) {
        
        do {
            let json = try ReadJSON.readJSONFromFile(fileName: "top") as? [String : Any]
            if let data = json?["data"] as? [String : Any] {
                
                let dataArray = try JSONSerialization.data(withJSONObject: data["children"] ?? [], options: [])
                let registers = try JSONDecoder().decode([Post].self, from: dataArray)
                result(registers, nil)
            } else {
                result(nil, nil)
            }
        } catch {
            result(nil, error)
        }
        
    }
}

