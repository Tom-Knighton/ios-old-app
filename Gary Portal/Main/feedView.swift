//
//  feedView.swift
//  Gary Portal
//
//  Created by Tom Knighton on 04/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import AZDialogView

import AVFoundation
import AVKit
class feedView: UITableViewController{
    
    public struct currentNum {
        static var postNum : Int = 10000
    }
    
    @IBOutlet var table: UITableView!
    
    var ref : DatabaseReference!
    var garyList = [feed]()
    var toUpdate : Bool = true
    
    var scroll : CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        self.loadPosts()
        self.ref.child("feed").observe(.childChanged, with: { (snapshot) in
            print("changed")
            
            if self.toUpdate == true {
                self.toUpdate = false
                self.scroll = self.table.contentOffset
                self.loadPosts()
            }
        })
        //turnOnObsv()
    }
    
    
    
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableViewAutomaticDimension
    }
    
    func loadPosts() {
        self.garyList.removeAll()
        self.ref.child("feed").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let child = child as! DataSnapshot
                if let childVal = child.value as? [String: AnyObject] {
                    let garyToShow = feed()
                    

                    let postNum = childVal["postNum"] as? Int ?? 10000
                    garyToShow.hasLiked = false
                    garyToShow.canLike = true
                    garyToShow.canDisLike = false
                    
                    if let likeL = childVal["likeList"] as? [String:String] {
                        for(_,person) in likeL {
                            if person == firstView.userStats.userName {
                                print("liked by current")
                                garyToShow.hasLiked = true
                            }
                        }
                    }
                  
                    let desc = childVal["desc"] as? String ?? ""
                    let posterName = childVal["posterName"] as? String ?? ""
                    let posterURL = childVal["posterURL"] as? String ?? ""
                    let postURL = childVal["postURL"] as? String ?? ""
                    let likes = childVal["Likes"] as? Int ?? 0
                    let comments = childVal["Comments"] as? Int ?? 0
                    let type = childVal["type"] as? String ?? ""
                    
                    
                    
                    
                    garyToShow.posterName = posterName
                    garyToShow.posterURL = posterURL
                    garyToShow.postURL = postURL
                    garyToShow.desc = desc
                    garyToShow.likes = likes
                    garyToShow.comments = comments
                    garyToShow.postNum = postNum
                    garyToShow.type = type
                    
                    
                    self.garyList.append(garyToShow)
                    
                    
                    
                }
            }
            self.table.reloadData()
            self.table.scrollToNearestSelectedRow(at: UITableViewScrollPosition.top, animated: false)
            
            self.toUpdate = true
            print("set to true")
            
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let standard = UserDefaults.standard
        if standard.bool(forKey: "compactGary") == true {
        
            let cell = table.dequeueReusableCell(withIdentifier: "compactGary", for: indexPath) as! feedCell
            cell.postBG.layer.cornerRadius = 10
            cell.postBG.layer.masksToBounds = true
            cell.posterImage.sd_setImage(with: URL(string: garyList[indexPath.row
                ].posterURL!), completed: nil)
            cell.postOptions.tag = garyList[indexPath.row].postNum!
            if garyList[indexPath.row].type == "Image" {
                //cell.postVid.isHidden = true
                //cell.postVid.isHidden = false
                print("image")
                cell.postImage.sd_setImage(with: URL(string: garyList[indexPath.row].postURL!), completed: nil)
            } else if garyList[indexPath.row].type == "video" {
                var player : AVPlayer? = nil
                var playerLayer : AVPlayerLayer? = nil
                var asset : AVAsset? = nil
                var playerItem: AVPlayerItem? = nil
                let videoURLWithPath = garyList[indexPath.row].postURL!
                let videoURL = NSURL(string: videoURLWithPath)
                
                asset = AVAsset(url: videoURL! as URL)
                playerItem = AVPlayerItem(asset: asset!)
                
                player = AVPlayer(playerItem: playerItem)
                
                playerLayer = AVPlayerLayer(player: player)
                playerLayer!.frame = cell.postImage.frame
                cell.postImage.layer.addSublayer(playerLayer!)
                
                player!.play()
            }
           
            cell.posterName.text = garyList[indexPath.row].posterName
            cell.likes.text = "Likes: "+"\(garyList[indexPath.row].likes ?? 0)"
            cell.comments.text = "Comments: "+"\(garyList[indexPath.row].comments ?? 0)"
            cell.desc.text = garyList[indexPath.row].desc
            
            if garyList[indexPath.row].hasLiked == true {
                print("liked")
                cell.heart.isHidden = true
                cell.heartFilled.isHidden = false
            } else {
                print("not liked")
                cell.heart.isHidden = false
                cell.heartFilled.isHidden = true
            }
            cell.heart.tag = garyList[indexPath.row].postNum!
            cell.heartFilled.tag = garyList[indexPath.row].postNum!
            
            cell.viewComments.tag = indexPath.row
            cell.viewComments.addTarget(self, action: #selector(feedView.commentsClicked), for: .touchUpInside)
            
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "garyCell", for: indexPath) as! feedCell
            cell.postBG.layer.cornerRadius = 10
            cell.postBG.layer.masksToBounds = true
            cell.posterImage.sd_setImage(with: URL(string: garyList[indexPath.row
                ].posterURL!), completed: nil)
            cell.postOptions.tag = garyList[indexPath.row].postNum!
            cell.postImage.sd_setImage(with: URL(string: garyList[indexPath.row].postURL!), completed: nil)
            cell.posterName.text = garyList[indexPath.row].posterName
            cell.likes.text = "Likes: "+"\(garyList[indexPath.row].likes ?? 0)"
            cell.comments.text = "Comments: "+"\(garyList[indexPath.row].comments ?? 0)"
            cell.desc.text = garyList[indexPath.row].desc
            
            if garyList[indexPath.row].hasLiked == true {
                print("liked")
                cell.heart.isHidden = true
                cell.heartFilled.isHidden = false
            } else {
                print("not liked")
                cell.heart.isHidden = false
                cell.heartFilled.isHidden = true
            }
            cell.heart.tag = garyList[indexPath.row].postNum!
            cell.heartFilled.tag = garyList[indexPath.row].postNum!
            
            cell.viewComments.tag = indexPath.row
            cell.viewComments.addTarget(self, action: #selector(feedView.commentsClicked), for: .touchUpInside)
            
            return cell
        }
        
       
      
        
        
    }
    @IBAction func optsPressed(_ sender: UIButton) {
        let postNum = sender.tag
        self.ref.child("feed").child("\(postNum)").observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            
            let optsAlert = AZDialogViewController(title: "Options", message: "Select an option")
            //let optsAlert = UIAlertController(title: "Options", message: "Select an option", preferredStyle: .alert)
            let dictionary = snapshot.value as? NSDictionary
            let owner = dictionary?["posterName"] as? String
            let senOwner = dictionary?["posterID"] as? String
            let postURL = dictionary?["postURL"] as! String
            //POST OWNED BY USER
            if owner == firstView.userStats.userName {
                optsAlert.addAction(AZDialogAction(title: "View Profile", handler: { (action) -> (Void) in
                    print("view profile")
                }))
                optsAlert.addAction(AZDialogAction(title: "Delete Post", handler: { (action) -> (Void) in
                    self.ref.child("feed").child("\(postNum)").removeValue()
                    self.loadPosts()
                }))
                optsAlert.addAction(AZDialogAction(title: "Save Image",  handler: { (action) -> Void in
                    let image = UIImageView()
                    image.sd_setImage(with: URL(string: postURL), completed: nil)
                    UIImageWriteToSavedPhotosAlbum(image.image!, nil, nil, nil)
                    optsAlert.dismiss()
                }))
                optsAlert.cancelTitle = "Cancel"
                optsAlert.cancelEnabled = true
                self.present(optsAlert, animated: false, completion: nil)
            } else {
                
                
                
                // POST NOT OWNED BY USER
                optsAlert.addAction(AZDialogAction(title: "View Profile", handler: { (action) -> (Void) in
                    print("view p")
                }))
                
                optsAlert.addAction(AZDialogAction(title: "Save Image",  handler: { (action) -> (Void) in
                    let image = UIImageView()
                    image.sd_setImage(with: URL(string: postURL), completed: nil)
                    UIImageWriteToSavedPhotosAlbum(image.image!, nil, nil, nil)
                    optsAlert.dismiss()
                }))
                optsAlert.addAction(AZDialogAction(title: "Report Post",  handler: { (action) -> (Void) in
                    optsAlert.dismiss(animated: false, completion: {
                        let optsOpt = AZDialogViewController(title: "Report", message: "Report Post")
                        optsOpt.addAction(AZDialogAction(title: "NSFW", handler: { (action) -> (Void) in
                            self.ref.child("reported").observeSingleEvent(of: .value, with: {(snap) -> Void in
                                let dict = snap.value as? NSDictionary
                                let reports = dict?["lastReport"] as? Int
                                let newN = reports! + 1
                                let reportInfo :[String:Any] = ["type":"post","post":"\(postNum)","reason":"NSFW","reporter":firstView.userStats.userName]
                                self.ref.child("reported").child("\(newN)").setValue(reportInfo)
                                self.ref.child("reported").child("lastReport").setValue(newN)
                                optsOpt.dismiss(animated: true, completion: {
                                    let OKdone = AZDialogViewController(title: "Information", message: "The post has been reported, it will be reviewed shortly. You may be contacted for further information regarding the report.")
                                    OKdone.addAction(AZDialogAction(title: "OK", handler: {(action) -> (Void) in
                                        OKdone.dismiss()
                                    }))
                                    self.present(OKdone, animated: false, completion: nil)
                                })
                                
                                
                            })
                            
                        }))
                        optsOpt.addAction(AZDialogAction(title: "Breaks Policy",  handler: { (action) in
                            self.ref.child("reported").observeSingleEvent(of: .value, with: {(snap) -> Void in
                                let dict = snap.value as? NSDictionary
                                let reports = dict?["lastReport"] as? Int
                                let newN = reports! + 1
                                let reportInfo :[String:Any] = ["type":"post","post":"\(postNum)","reason":"Policy","reporter":firstView.userStats.userName]
                                self.ref.child("reported").child("\(newN)").setValue(reportInfo)
                                self.ref.child("reported").child("lastReport").setValue(newN)
                                optsOpt.dismiss(animated: true, completion: {
                                    let OKdone = AZDialogViewController(title: "Information", message: "The post has been reported, it will be reviewed shortly. You may be contacted for further information regarding the report.")
                                    OKdone.addAction(AZDialogAction(title: "OK", handler: {(action) -> (Void) in
                                        OKdone.dismiss()
                                    }))
                                    self.present(OKdone, animated: false, completion: nil)
                                })
                                
                            })
                        }))
                        optsOpt.addAction(AZDialogAction(title: "Breaks GaryGram", handler: { (action) in
                            self.ref.child("reported").observeSingleEvent(of: .value, with: {(snap) -> Void in
                                let dict = snap.value as? NSDictionary
                                let reports = dict?["lastReport"] as? Int
                                let newN = reports! + 1
                                let reportInfo :[String:Any] = ["type":"post","post":"\(postNum)","reason":"Breaks GG","reporter":firstView.userStats.userName]
                                self.ref.child("reported").child("\(newN)").setValue(reportInfo)
                                self.ref.child("reported").child("lastReport").setValue(newN)
                                
                                optsOpt.dismiss(animated: true, completion: {
                                    let OKdone = AZDialogViewController(title: "Information", message: "The post has been reported, it will be reviewed shortly. You may be contacted for further information regarding the report.")
                                    OKdone.addAction(AZDialogAction(title: "OK", handler: {(action) -> (Void) in
                                        OKdone.dismiss()
                                    }))
                                    self.present(OKdone, animated: false, completion: nil)
                                })
                                
                            })
                        }))
                        optsOpt.cancelTitle = "Cancel"
                        optsOpt.cancelEnabled = true
                        self.present(optsOpt, animated: false,completion: nil)
                        
                    })
                    
                }))
                optsAlert.cancelTitle = "Cancel"
                optsAlert.cancelEnabled = true
                self.present(optsAlert, animated: false, completion: nil)
            }
            
            
        })
        
    }
    
    @objc func commentsClicked(sender: UIButton) {
        currentNum.postNum = garyList[sender.tag].postNum!
        performSegue(withIdentifier: "feedToComments", sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return garyList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let standard = UserDefaults.standard
        if standard.bool(forKey: "compactGary") == true {
            return 300
        } else {
            return 461
        }
        
    }

   

}
