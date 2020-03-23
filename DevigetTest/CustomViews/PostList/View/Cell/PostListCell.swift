//
//  PostListCell.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class PostListCell: NSTableCellView {
    @IBOutlet weak var separatedView : NSView!
    @IBOutlet weak var unreadStatusLabel: NSTextField!
    @IBOutlet weak var timeAgo: NSTextField!
    @IBOutlet weak var commentsLabel: NSTextField!
    @IBOutlet weak var authorLabel: NSTextField!
    @IBOutlet weak var thumbnailImage : NSImageView!
    @IBOutlet weak var titleLabel : NSTextField!
    
    @IBOutlet weak var dismissButtonOutlet : NSButton!
    
    var didDismissButtonPressed : ((NSTableCellView) -> ())?
    
    override func draw(_ dirtyRect: NSRect) {
        self.wantsLayer = true
        
        titleLabel.maximumNumberOfLines = 3
        titleLabel.lineBreakMode = .byWordWrapping
        separatedView.wantsLayer = true
        separatedView.layer?.backgroundColor = NSColor.white.cgColor
        
        dismissButtonOutlet.wantsLayer = true
               dismissButtonOutlet.layer?.cornerRadius = 10
               dismissButtonOutlet.layer?.borderColor = NSColor.orange.cgColor
               dismissButtonOutlet.layer?.borderWidth = 1
        
    }
    
    @IBAction func pressed(_ sender: NSButton) {
        didDismissButtonPressed?(self)
       
    }
}

