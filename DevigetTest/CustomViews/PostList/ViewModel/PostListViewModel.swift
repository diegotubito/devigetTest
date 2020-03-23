//
//  PostListViewModel.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class PostListViewModel: PostListViewModelContract {
    var _view : PostListViewContract!
    var model: PostListModel!
    var service : RedditService!
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    
    required init(withView view: PostListViewContract) {
        _view = view
        model = PostListModel()
        service = RedditService()
    }
    
    func loadPostFromJSONFile() {
        
        service.getPostFromJSONFile { (posts, error) in
            guard let posts = posts else {
                self._view.showError(error?.localizedDescription ?? "unkwown error")
                return
            }
            model.posts = posts
            _view.showSuccess(posts: posts)
        }
    }
    
    func loadNetoworkPosts() {
        service.searchSubreddit(for: "") { (json, error) in
            do {
                if let data = json?[Post.Keys.data] as? [String : Any] {
                    
                    let dataArray = try JSONSerialization.data(withJSONObject: data[Post.Keys.children] ?? [], options: [])
                    let registers = try JSONDecoder().decode([Post].self, from: dataArray)
                    
                    self.model.posts = registers
                    self._view.showSuccess(posts: registers)
                } else {
                    self._view.showError(Constants.Messages.GeneralNetworkErrorMessage)
                }
            } catch {
                self._view.showError(Constants.Messages.GeneralNetworkErrorMessage)
                
            }
        }
       
    }
    
    func downloadImageFromUrl(url: String, result: @escaping (NSImage?, String) -> Void, fail: @escaping (ServiceError?, String) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? NSImage {
            print("image loaded from cache")
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
                let imageToCache = image
                self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                result(imageToCache, url)
                
                return
            }
        }
        dataTask.resume()
        
    }
    
    func getPosts() -> [Post] {
        return model.posts
    }
}

