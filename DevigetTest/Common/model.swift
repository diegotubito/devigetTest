//
//  model.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Foundation

struct Post : Decodable {
    var kind : String
    var data : PostData
    
    struct Keys {
        static let data = "data"
        static let children = "children"
    }
}

struct PostData : Decodable{
    var title : String
    var num_comments : Int
    var url : String
    var created : Double
    var thumbnail : String
    var name : String
    var author : String
    
    var unreadStatus : Bool?
}

