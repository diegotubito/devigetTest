//
//  PostListView.swift
//  DevigetTest
//
//  Created by David Diego Gomez on 22/03/2020.
//  Copyright © 2020 David Diego Gomez. All rights reserved.
//

import Cocoa

class PostListView: NSView {
    @IBOutlet var myView: NSView!
    @IBOutlet weak var titleView: NSView!
    @IBOutlet weak var dismissAllOutlet: NSButton!
    @IBOutlet var tableViewPost : NSTableView!
    
    var didSelectPost : ((Post?) -> ())?
    var viewModel : PostListViewModelContract!
    
    override init(frame frameRect: NSRect) {
        super .init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super .init(coder: decoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PostListView", owner: self, topLevelObjects: nil)
        myView.frame = self.frame
        addSubview(myView)
        tableViewConfiguration()
        viewModel = PostListViewModel(withView: self)
        defaultColors()
        startLoading()
    }
    
    private func tableViewConfiguration() {
        tableViewPost.delegate = self
        tableViewPost.dataSource = self
        tableViewPost.backgroundColor = Constants.Colors.PostItemCellBackgroundColor
    }
    
    private func defaultColors() {
        titleView.wantsLayer = true
        titleView.layer?.backgroundColor = Constants.Colors.Background.cgColor
        dismissAllOutlet.wantsLayer = true
        dismissAllOutlet.layer?.backgroundColor = Constants.Colors.Background.cgColor
    }
    
    func startLoading() {
        viewModel.loadNetoworkPosts()
        //viewModel.loadPostFromJSONFile()
    }
    
    @IBAction func dismissAllPressed(_ sender: Any) {
        let posts = viewModel.getPosts()
        var ind = IndexSet()
        for (x, _) in posts.enumerated() {
            ind.insert(x)
        }
        viewModel.model.posts.removeAll()
        tableViewPost.removeRows(at: ind, withAnimation: .effectFade)
        tableViewPost.deselectAll(nil)
    }
    
}


extension PostListView: PostListViewContract {
    func showSuccess(posts: [Post]) {
        reloadList()
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let a: NSAlert = NSAlert()
            a.messageText = "Network Error"
            a.informativeText = message
            a.addButton(withTitle: "OK")
            a.alertStyle = NSAlert.Style.warning
            
            a.beginSheetModal(for: self.window!, completionHandler: { (modalResponse: NSApplication.ModalResponse) -> Void in
                if(modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn){
                    self.viewModel.loadPostFromJSONFile()
                }
            })
        }
    }
    
    func reloadList() {
        DispatchQueue.main.async {
            self.tableViewPost.reloadData()
        }
    }
}


extension PostListView: NSTableViewDataSource, NSTableViewDelegate {
   
    func numberOfRows(in tableView: NSTableView) -> Int {
        if viewModel == nil {return 0}
        let posts = self.viewModel.getPosts()
        return posts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
      
        let cell : PostListCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "defaultRow"), owner: self) as! PostListCell
        
        let data = self.viewModel.getPosts()[row].data
    
        let author = data.author
        let date = Date(timeIntervalSince1970: data.created)
        let createdAt = date.getElapsedInterval()
        let title = data.title
        let comments = data.num_comments
        let imageUrl = data.thumbnail
        let unreadStatus = data.unreadStatus ?? true
        
    
        cell.authorLabel.stringValue = author
        cell.titleLabel.stringValue = title
        cell.commentsLabel.stringValue = String(comments) + " comments"
        cell.timeAgo.stringValue = createdAt
        if unreadStatus {
            cell.unreadStatusLabel.stringValue = "🔵"
        } else {
            cell.unreadStatusLabel.stringValue = ""
        }
        
        cell.didDismissButtonPressed = { cell in
            let row = self.tableViewPost.row(for: cell)
            
            if row != -1 {
                self.viewModel.model.posts.remove(at: row)
                self.tableViewPost.removeRows(at: IndexSet(arrayLiteral: row), withAnimation: .effectFade)
            }
        }
        
        viewModel.downloadImageFromUrl(url: imageUrl, result: { (image, url) in
            if url == data.thumbnail {
                DispatchQueue.main.async {
                    if image != nil {
                        cell.thumbnailImage.image = image
                    } else {
                        cell.thumbnailImage.image = #imageLiteral(resourceName: "noImage")
                    }
                }
            }
        }) { (error, url) in
            if url == data.thumbnail {
                DispatchQueue.main.async {
                    cell.thumbnailImage.image = #imageLiteral(resourceName: "noImage")
                }
                
            }
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let myTable = notification.object as? NSTableView {
            
            if myTable == tableViewPost {
                let row = myTable.selectedRow
                let counts = viewModel.getPosts().count
                if counts == 0 || row == -1  {
                    didSelectPost?(nil)
                    return
                    
                }
                let selectedPost = viewModel.model.posts[row]
                viewModel.model.posts[row].data.unreadStatus = false
                let index = IndexSet(arrayLiteral: row)
                let collumn = IndexSet(arrayLiteral: 0)
                tableViewPost.reloadData(forRowIndexes: index, columnIndexes: collumn)
                
                didSelectPost?(selectedPost)
            }
            
        }
        
    }
    
    
    //estos dos bloques son para cambiar el color y estilo de la seleccion
    class MyNSTableRowView: NSTableRowView {
      
        override func drawSelection(in dirtyRect: NSRect) {
            if self.selectionHighlightStyle != .none {
                let selectionRect = NSInsetRect(self.bounds, 0, 0)
                
                Constants.Colors.SelectionItem.setFill()
                let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 0, yRadius: 0)
                selectionPath.fill()
                selectionPath.stroke()
                
            }
            
        }
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return MyNSTableRowView()
    }
    
}

