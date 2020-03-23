//
//  XibView.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class XibView: NSView {
    var xibName : String?
    
    override init(frame frameRect: NSRect) {
        super .init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        commonInit()
    }
    
    internal func commonInit() {
        let xibName = self.xibName ?? String(describing: type(of: self))
        
        var topLevelObjects: NSArray?
        if Bundle.main.loadNibNamed(xibName, owner: self, topLevelObjects: &topLevelObjects) {
            if let myView = topLevelObjects?.first(where: { $0 is NSView } ) as? NSView {
                myView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                addSubview(myView)
            }
        }
        
    }
}


