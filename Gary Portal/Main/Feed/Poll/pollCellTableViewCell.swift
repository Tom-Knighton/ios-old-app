//
//  pollCellTableViewCell.swift
//  Gary Portal
//
//  Created by Tom Knighton on 18/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class pollCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var postOptions: UIButton!
    @IBOutlet weak var pollQuestion: UILabel!
    @IBOutlet weak var question1B: UIButton!
    @IBOutlet weak var question2B: UIButton!
    @IBOutlet weak var questionFinish: UILabel!
    
    var canVote : Bool = true
    var ref : DatabaseReference!
    override func awakeFromNib() {
        super.awakeFromNib()
        canVote = true
        ref = Database.database().reference().child("polls")
    }
    
    @IBAction func vote1Pressed(_ sender: UIButton) {
        let pollNum = sender.tag
        
        ref.child("\(pollNum)").queryOrderedByValue().observe(.value, with: {(snapshot) in
            
            if self.canVote == true {
                self.canVote = false
                let dict = snapshot.value as? [String:AnyObject]
                let oldTotal = dict?["totalVotes"] as? Int
                let oldOne = dict?["vote1Votes"] as? Int
                
                let newTotal = oldTotal! + 1
                let newOne = oldOne! + 1
                
                
                self.ref!.child("vote1Voters").child(firstView.userStats.userName).setValue(firstView.userStats.userName)
                self.ref!.child("\(pollNum)").child("totalVotes").setValue(newTotal)
                self.ref!.child("\(pollNum)").child("vote1Votes").setValue(newOne)


            }
            
            
            
        })
        
        
    }
    
    @IBAction func vote2Pressed(_ sender: UIButton) {
        let pollNum = sender.tag
        
        ref.child("\(pollNum)").queryOrderedByValue().observe(.value, with: {(snapshot) in
            
            if self.canVote == true {
                self.canVote = false
                let dict = snapshot.value as? [String:AnyObject]
                let oldTotal = dict?["totalVotes"] as? Int
                let oldOne = dict?["vote2Votes"] as? Int
                
                let newTotal = oldTotal! + 1
                let newOne = oldOne! + 1
                
                
                self.ref!.child("vote2Voters").child(firstView.userStats.userName).setValue(firstView.userStats.userName)
                self.ref!.child("\(pollNum)").child("totalVotes").setValue(newTotal)
                self.ref!.child("\(pollNum)").child("vote2Votes").setValue(newOne)
                
                
            }
            
            
            
        })
    }
    
    

    

}
