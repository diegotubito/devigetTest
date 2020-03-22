//
//  ServiceTest.swift
//  DevigetTestTests
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import XCTest
@testable import DevigetTest

class MockRedditService: RedditServiceProtocol {
    var shouldReturnError = false
  
    func reset() {
        shouldReturnError = false
    }
    
    func searchSubreddit(for query: String, completion: @escaping ([String : Any]?, ServiceError?) -> ()) {
        
        if shouldReturnError {
            completion(nil, ServiceError.server_error)
            return
        }
        do {
            let json = try ReadJSON.readJSONFromFile(fileName: "top") as? [String : Any]
            completion(json, nil)
        } catch {
            completion(nil, ServiceError.body_serialization_error)
        }
    }
}

class TestServiceManager: XCTestCase {
    let service = MockRedditService()
    
    func testRetrieveData() {
        //uncomment the following two lines, when mock test is used.
        service.reset()
        service.shouldReturnError = false
        
        let expectation = self.expectation(description: "I expect to receive a response from API call")
        
        service.searchSubreddit(for: "") { (json, error) in
            XCTAssertNil(error)
            guard (json?[Post.Keys.data] as? [String : Any]) != nil else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}

