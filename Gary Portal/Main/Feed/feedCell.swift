//
//  feedCell.swift
//  Gary Portal
//
//  Created by Tom Knighton on 04/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class feedCell: UITableViewCell {

//    @IBOutlet weak var postBG: UIView!
//    @IBOutlet weak var postOptions: UIButton!
//    @IBOutlet weak var posterName: UILabel!
//    @IBOutlet weak var posterImage: UIImageView!
//    @IBOutlet weak var postImage: UIImageView!
//
    
    @IBOutlet weak var postBG: UIView!
    @IBOutlet weak var postOptions: UIButton!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var viewComments: UIButton!
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var heartFilled: UIButton!
    
    var ref : DatabaseReference!
    
    var canLike : Bool = true
    override func awakeFromNib() {
        ref = Database.database().reference().child("feed")
        canLike = true
    }
    @IBAction func filledClicked(_ sender: UIButton) {
        let postNum = sender.tag
        print("\(postNum)"+" is num")
        ref.child("\(postNum)").queryOrderedByValue().observe(.value, with: {(snapshot) in
            if self.canLike == true {
                self.canLike = false
                let dict = snapshot.value as? [String:AnyObject]
                let oldN = dict?["Likes"] as? Int
                let newN = oldN! - 1
                
                if let likers = dict?["likeList"] as? [String:String] {
                    for(_,person) in likers {
                        if person == firstView.userStats.userName {
                            self.ref.child("\(postNum)").child("likeList").child(firstView.userStats.userName).removeValue()
                        }
                    }
                }
                
                self.ref!.child("\(postNum)").child("Likes").setValue(newN)
                
                self.heart.isHidden = false
                self.heartFilled.isHidden = true
            }
            
            
        })
        self.canLike = true
    }
    
    @IBAction func heartClicked(_ sender: UIButton) {
        let postNum = sender.tag
        print("\(postNum)"+" is num")
        ref.child("\(postNum)").queryOrderedByValue().observe(.value, with: {(snapshot) in
            if self.canLike == true {
                self.canLike = false
                let dict = snapshot.value as? NSDictionary
                let oldN = dict?["Likes"] as? Int
                let newN = oldN! + 1
                
                self.ref!.child("\(postNum)").child("likeList").child(firstView.userStats.userName).setValue(firstView.userStats.userName)
                self.ref!.child("\(postNum)").child("Likes").setValue(newN)
                
                self.heart.isHidden = true
                self.heartFilled.isHidden = false
            }
            
            
        })
        self.canLike = true
    }
    
    
}
