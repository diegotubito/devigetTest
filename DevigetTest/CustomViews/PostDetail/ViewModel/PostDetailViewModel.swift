//
//  PostDetailViewModel.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class PostDetailViewModel: PostDetailViewModelContract {
    
    var model: PostDetailModel!
    var _view : PostDetailViewContract!
    var imageCache = NSCache<AnyObject, AnyObject>()
    var service : RedditService!
    
    required init(withView view: PostDetailViewContract) {
        _view = view
        model = PostDetailModel()
        service = RedditService()
    }
    
    func getSelectedPost() -> Post? {
        return model.post
    }
    
    
    
    func downloadImageFromUrl(url: String, result: @escaping (NSImage?, String) -> Void, fail: @escaping (ServiceError?, String) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? NSImage {
            result(imageFromCache, url)
   
            return
        }
        
        guard let finalURL = URL(string: url) else {
            result(nil, url)
            
            return
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: finalURL) { (
            data, response, error) -> Void in
            guard error == nil else {
                fail(error as? ServiceError, url)
                
                return
            }
            
            guard let data = data, let image = NSImage(data: data) else {
                fail(ServiceError.emptyData, url)
                
                return
            }
            
            DispatchQueue.main.async {
                //save loaded image to cache for better performance
                let imageToCache = image
                self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                result(imageToCache, url)
                
                return
            }
            
            
        }
        dataTask.resume()
        
    }
    
    func setSelectedPost(_ post: Post?) {
        model.post = post
        self._view.showLoading()
        self._view.clearData()
        if post == nil {
            _view.hideLoading()
            
            return
        }
        _view.displayText()
        
        let thumbnail = post?.data.thumbnail ?? ""
        
        self.downloadImageFromUrl(url: thumbnail, result: { (image, url) in
            self._view.hideLoading()
            self.model.image = image
            self._view.displayImage()
        }) { (error, url) in
            self._view.hideLoading()
            self.model.image = nil
            self._view.displayImage()

        }
    }
    
}
