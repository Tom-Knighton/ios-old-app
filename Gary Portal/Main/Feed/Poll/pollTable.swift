//
//  pollTable.swift
//  Gary Portal
//
//  Created by Tom Knighton on 18/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase


class pollTable: UITableViewController {
    
    public struct currentNum {
        static var pollNum : Int = 9999999
    }

    @IBOutlet var table: UITableView!
    var ref : DatabaseReference!
    var pollList = [poll]()
    var toUpdate : Bool = true
    
    var scroll : CGPoint = CGPoint(x: 0, y: 0)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.loadPolls()
        self.ref.child("poll").observe(.childChanged, with: {(snapshot) in
            
            if self.toUpdate == true {
                self.toUpdate = false
                self.scroll = self.table.contentOffset
                self.loadPolls()
            }
        })
        
    }

    fileprivate var heightDictionary: [Int : CGFloat] = [:]

    func loadPolls() {
        self.pollList.removeAll()
        ref.child("poll").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String: AnyObject] {
                    let pollToShow = poll()
                    
                    let postNum = childVal["pollNum"] as? Int
                    pollToShow.hasVoted = false
                    pollToShow.canVote = true
                    
                    if let vote1Voters = childVal["vote1Voters"] as? [String:String] {
                        for(_,person) in vote1Voters {
                            if person == firstView.userStats.userName {
                                pollToShow.hasVoted = true
                                pollToShow.canVote = false
                            }
                        }
                    }
                    
                    if let vote2Voters = childVal["vote2Voters"] as? [String:String] {
                        for(_,person) in vote2Voters {
                            if person == firstView.userStats.userName {
                                pollToShow.hasVoted = true
                                pollToShow.canVote = false
                            }
                        }
                    }
                    
                    let ques = childVal["question"] as? String
                    let vote1 = childVal["vote1"] as? String
                    let vote2 = childVal["vote2"] as? String
                    let totalVotes = childVal["totalVotes"] as? Int
                    let posterURL = childVal["posterURL"] as? String
                    let posterName = childVal["posterName"] as? String
                    let posterID = childVal["posterID"] as? String
                    let vote1Votes = childVal["vote1Votes"] as? Int
                    let vote2Votes = childVal["vote2Votes"] as? Int
                    
                    pollToShow.question = ques
                    pollToShow.opt1 = vote1
                    pollToShow.opt2 = vote2
                   // pollToShow.totalVotes = totalVotes
                    pollToShow.posterURL = posterURL
                    pollToShow.posterName = posterName
                    pollToShow.votes1 = vote1Votes
                    pollToShow.votes2 = vote2Votes
                    pollToShow.posterID = posterID
                    
                    self.pollList.append(pollToShow)
                    
                }
            }
            
            self.table.reloadData()
            self.table.scrollToNearestSelectedRow(at: UITableViewScrollPosition.top, animated: false)
            self.toUpdate = true
        }
    }


    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "pollCell", for: indexPath) as! pollCellTableViewCell
        
        if pollList[indexPath.row].hasVoted == true {
            cell.question1B.isHidden = true
            cell.question2B.isHidden = true
            cell.questionFinish.isHidden = false
           // cell.questionFinish.text = "Thank you for voting!\n"+pollList[indexPath.row].opt1+" : "+pollList[indexPath.row].votes1+" votes\n"+pollList[indexPath.row].opt2+" : "+pollList[indexPath.row].votes2+" votes"
        } else {
            cell.question1B.isHidden = false
            cell.question2B.isHidden = false
            cell.questionFinish.isHidden = true
        }
        
        cell.posterName.text = pollList[indexPath.row].posterName
        //cell.question1B.tag = pollList[indexPath.row].pollNum
        //cell.question2B.tag = pollList[indexPath.row].pollNum

        return cell
        
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  pollList.count
    }



}
