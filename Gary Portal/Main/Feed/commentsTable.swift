//
//  commentsTable.swift
//  Gary Portal
//
//  Created by Tom Knighton on 06/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseDatabase
import MGSwipeTableCell
class commentsTable: UITableViewController {

    var ref : DatabaseReference!
    var commentList = [comment]()
    
    var postNum : Int = 10000
    
    var toUpdate : Bool = true
    var scroll : CGPoint = CGPoint(x: 0, y: 0)
    
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(loadComments), for: .valueChanged)
        ref = Database.database().reference()
        postNum = feedView.currentNum.postNum
        print(postNum)
        
    
        ref.child("feed").child("\(postNum)").child("commentList").queryOrderedByKey().observe(.childChanged, with: { (snapshot) in
            if self.toUpdate == true {
                self.scroll = self.table.contentOffset
                self.toUpdate = false
                self.loadComments()
            }

        })

        loadComments()
        
        
    }
    
    
    
    @objc func loadComments() {
        self.commentList.removeAll()
        ref!.child("feed").child("\(postNum)").child("commentList").queryOrderedByValue().observeSingleEvent(of: .value, with: {(snapshot)  in
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String:AnyObject] {
                    let date = childVal["date"] as? String ?? "99/99/99"
                    let commenterURL = childVal["commenterurl"] as? String ?? ""
                    let commentC = childVal["comment"] as? String ?? ""
                    
                    let commentToShow = comment()
                    commentToShow.comment = commentC
                    commentToShow.date = date
                    commentToShow.commenterURL = commenterURL
                    self.commentList.append(commentToShow)
                }
            }
            self.toUpdate = true
            self.refreshControl?.endRefreshing()
            self.table.reloadData()
        })
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "commentC", for: indexPath) as? commentCell
        cell?.commenterURL.sd_setImage(with: URL(string: commentList[indexPath.row].commenterURL!), completed: nil)
        cell?.comment.text = commentList[indexPath.row].comment
        cell?.date.text = commentList[indexPath.row].date
        
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentList.count
    }

}
