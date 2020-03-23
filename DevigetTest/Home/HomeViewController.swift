//
//  ViewController.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController {
    var postListView : PostListView!
    @IBOutlet weak var postListContainerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupWindow()
        
    }
    
    override func viewDidAppear() {
        super .viewDidAppear()
         self.createPostListView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func setupWindow() {
        let (screenWidth, screenHeight) = getScreenSize()
        let windowWidth : CGFloat = screenWidth * 0.8
        let windowHeight : CGFloat = screenHeight * 0.8
        let newRect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        let newSize = NSSize(width: windowWidth, height: windowHeight)
        view.setFrameSize(newSize)
        view.window?.setFrame(newRect, display: false)
    }
    
    func getScreenSize() -> (CGFloat, CGFloat){
        if let screen = NSScreen.main {
            let rect = screen.frame
            let height = rect.size.height
            let width = rect.size.width
            
            return (width, height)
        }
        return (0, 0)
    }
    
    func createPostListView() {
        postListView = PostListView(frame: CGRect(x: 0, y: 0, width: postListContainerView.frame.width, height: postListContainerView.frame.height))
        postListContainerView.addSubview(postListView)
        
        postListView.didSelectPost = { selectedPost in
            
        }
        
    }
    
}

