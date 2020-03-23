//
//  PostDetailView.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class PostDetailView : XibView, PostDetailViewContract {
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var authorLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    
    var viewModel : PostDetailViewModelContract!
  
    override func commonInit() {
        super .commonInit()
        titleLabel.maximumNumberOfLines = 0
        titleLabel.lineBreakMode = .byCharWrapping
        viewModel = PostDetailViewModel(withView: self)
        addGesture()
    }
    
    private func addGesture() {
        let click = NSClickGestureRecognizer(target: self, action: #selector(imageClickedHandler))
        imageView.addGestureRecognizer(click)
    }
    
    @objc func imageClickedHandler() {
        let author = viewModel.getSelectedPost()?.data.author ?? "noName"
        let fileName = "\(author).png"
        let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        imageView.image?.writePNG(toURL: downloadsDirectory)
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimation(nil)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimation(nil)
        }
    }
    
    func displayText() {
        DispatchQueue.main.async {
            let selectedPost = self.viewModel.getSelectedPost()
            
            self.authorLabel.stringValue = selectedPost?.data.author ?? ""
            self.titleLabel.stringValue = selectedPost?.data.title ?? ""
        }
    }
    
    func displayImage() {
          DispatchQueue.main.async {
              let image = self.viewModel.model.image
              
              if image != nil {
                  self.imageView.image = image
              } else {
                  self.imageView.image = #imageLiteral(resourceName: "noImage")
              }
          }
      }
    
    func clearData() {
        authorLabel.stringValue = ""
        titleLabel.stringValue = ""
        imageView.image = nil
    }
    
}

