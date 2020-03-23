//
//  PostDetailViewModelProtocol.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

protocol PostDetailViewModelContract {
    init(withView view: PostDetailViewContract)
    func getSelectedPost() -> Post?
    var model : PostDetailModel! {get}
    func downloadImageFromUrl(url: String, result: @escaping (NSImage?, String) -> Void, fail: @escaping (ServiceError?, String) -> Void)
    func setSelectedPost(_ post: Post?)
}

protocol PostDetailViewContract {
    func showLoading()
    func hideLoading()
    func displayImage()
    func displayText()
    func clearData()
}


