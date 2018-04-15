//
//  profileView.swift
//  Gary Portal
//
//  Created by Tom Knighton on 28/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class profileView: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var miscView: UIView!
    
    @IBOutlet weak var staffButton: UIButton!
    @IBOutlet weak var prayerButton: UIButton!
    @IBOutlet weak var rrButton: UIButton!
    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var userData : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.staffButton.isHidden = true

        userData = Database.database().reference()
        userData.observe(.value, with: {(snapshot) in
            
            let dict = snapshot.value as? NSDictionary
            
            let aPoints = dict?["aPoints"] as? Int ?? 0
            let pPoints = dict?["pPoints"] as? Int ?? 0
            let aRank = dict?["aRank"] as? String ?? ""
            let pRank = dict?["pRank"] as? String ?? ""
            let uName = dict?["fullName"] as? String ?? ""
            let sName = dict?["sName"] as? String ?? ""
            let staff = dict?["staff"] as? Bool ?? false
            let admin = dict?["admin"] as? Bool ?? false
            let url = dict?["urlToImage"] as? String ?? ""
            let team = dict?["team"] as? String ?? ""
            
           
            //let banned = dict?["banned"] as? Bool ?? false
            
            firstView.userStats.admin = admin
            firstView.userStats.staff = staff
            firstView.userStats.aPoints = aPoints
            firstView.userStats.pPoints = pPoints
            firstView.userStats.aRank = aRank
            firstView.userStats.pRank = pRank
            firstView.userStats.userName = uName
            firstView.userStats.sName = sName
            firstView.userStats.url = url
            firstView.userStats.team = team
            
            if staff == true {
                print("staff")
                self.staffButton.titleLabel?.text = "Staff Panel"
                self.staffButton.isHidden = false
            }
            else if admin == true {
                print("admin")
                self.staffButton.titleLabel?.text = "Admin Panel"
                self.staffButton.isHidden = false
            }
        })
        let path = UIBezierPath(roundedRect: self.headerView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.headerView.layer.mask = maskLayer
        
        self.statsView.layer.cornerRadius = 20
        self.statsView.layer.masksToBounds = true
        
        self.pointsView.layer.cornerRadius = 20
        self.pointsView.layer.masksToBounds = true
        
        self.miscView.layer.cornerRadius = 20
        self.miscView.layer.masksToBounds = true
        
        
        self.staffButton.layer.cornerRadius = 20
        self.staffButton.layer.masksToBounds = true
        self.prayerButton.layer.cornerRadius = 20
        self.prayerButton.layer.masksToBounds = true
        self.rrButton.layer.cornerRadius = 20
        self.rrButton.layer.masksToBounds = true
        self.mapsButton.layer.cornerRadius = 20
        self.mapsButton.layer.masksToBounds = true
        self.bookButton.layer.cornerRadius = 20
        self.bookButton.layer.masksToBounds = true
        self.settingsButton.layer.cornerRadius = 20
        self.settingsButton.layer.masksToBounds = true
      
    }
    
    
    @IBAction func prayerPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    

}
