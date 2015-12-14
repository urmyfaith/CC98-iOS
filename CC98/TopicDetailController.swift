//
//  PostDetailController.swift
//  CC98
//
//  Created by CCNT on 12/13/15.
//  Copyright © 2015 Orpine. All rights reserved.
//



import Foundation
import UIKit
import SwiftyJSON

class TopicDetailController:UITableViewController{
    
    var loading:Bool = false
    var topic:CC98Topic?
    var posts=Array<CC98Post>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 150;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        loadData(true)
        self.tableView.addHeaderWithCallback{
            self.loadData(true)
        }
        self.tableView.addFooterWithCallback{
            
            if(self.posts.count>0) {
                self.loadData(false)
            }
        }
        self.tableView.headerBeginRefreshing()
    }
    
    func loadData(isPullRefresh:Bool){
//        data=X.GetHotTopic();
        
        if self.loading {
            return
        }
        self.loading = true
        let posts=topic!.loadPosts(isPullRefresh)
        self.loading = false
        
        if(isPullRefresh){
            self.tableView.headerEndRefreshing()
        }
        else{
            self.tableView.footerEndRefreshing()
        }
        if posts.count==0 && isPullRefresh{
            let alert = UIAlertView(title: "网络异常", message: "请检查网络设置", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        if(posts.count==0){
            return
        }
        
        if(isPullRefresh){
            
            self.posts.removeAll(keepCapacity: false)
        }
        
        
        for  it in posts {
            
            self.posts.append(it);
        }
        
        self.tableView.reloadData()
        
        
        
        
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        //TODO
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.posts.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! PostCell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        cell.content=posts[indexPath.row].content
        cell.setView()
//        let baseURL = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
//        cell.webView.loadHTMLString(posts[indexPath.row].content, baseURL: baseURL)
//        cell.webView.scrollView.bounces = false
//        cell.webView.layer.cornerRadius = 6;
//        cell.webView.layer.masksToBounds = true
//        let height=cell.webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")
//        let size=cell.webView.sizeThatFits(CGSizeZero)
//        var frame=cell.webView.frame
//        frame.size.height=size.height
//        cell.webView.frame=frame
//        cell.webView.loadHTMLString(posts[indexPath.row].content,baseURL:nil)
        cell.updateConstraintsIfNeeded()
        // cell.contentView.backgroundColor = UIColor.grayColor()
        
        // cell.selectedBackgroundView = cell.containerView
        
        
        return cell
    }
    var prototypeCell:PostCell?
    
    private func configureCell(cell:PostCell,indexPath: NSIndexPath,isForOffscreenUse:Bool){
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
        cell.content=posts[indexPath.row].content
        cell.setView()
        
        cell.selectionStyle = .None;
    }
//    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostCell
//        return cell.webView.frame.height
//        
//    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if prototypeCell == nil
        {
            self.prototypeCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as? PostCell
        }
        
        
        
        
        self.configureCell(prototypeCell!, indexPath: indexPath, isForOffscreenUse: false)
        
        
        self.prototypeCell?.setNeedsUpdateConstraints()
        self.prototypeCell?.updateConstraintsIfNeeded()
        self.prototypeCell?.setNeedsLayout()
        self.prototypeCell?.layoutIfNeeded()
        
        
        let size = self.prototypeCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        return size.height;
        
    }
}