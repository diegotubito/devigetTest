//
//  Constants.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

struct Constants {
    struct Messages {
        static let GeneralNetworkErrorMessage = "This is a testing feature, in case Reddit Url is not working properly in your region, data will be parsed from top.json file provided by Devit-Example requirements"
    }
    struct Limit {
        static let limitNumberOfPost = 50
    }
    struct Colors {
        static let UnreadStatus = NSColor.blue
        static let ReadStatus = NSColor.clear
        static let SelectionItem = NSColor.darkGray
        static let PostItemCellBackgroundColor = NSColor.black
        static let Background = NSColor.black
    }
}

