//
//  PostListViewModelProtocol.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

protocol PostListViewModelContract {
    init(withView view: PostListViewContract)
    var model : PostListModel! {get set}
    func loadNetoworkPosts()
    func loadPostFromJSONFile()
    func downloadImageFromUrl(url: String, result: @escaping (NSImage?, String) -> Void, fail: @escaping (ServiceError?, String) -> Void)
    func getPosts() -> [Post]
    
}

protocol PostListViewContract {
    func showSuccess(posts: [Post])
    func showError(_ message: String)
}
