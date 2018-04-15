//
//  mainProfile.swift
//  Gary Portal
//
//  Created by Tom Knighton on 03/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Pastel
import EZYGradientView
import SDWebImage
import SafariServices
class mainProfile: UITableViewController {

    @IBOutlet weak var prayerButton: UIButton!
    
    @IBOutlet weak var defsButton: EZYGradientView!
    @IBOutlet weak var reqsButton: UIButton!
    @IBOutlet weak var compButton: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var rR: EZYGradientView!
    
    
    
    @IBOutlet weak var aPView: UIView!
    @IBOutlet weak var pPView: UIView!
    @IBOutlet weak var teamView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var uName: UILabel!
    @IBOutlet weak var sName: UILabel!
    @IBOutlet weak var aP: UILabel!
    @IBOutlet weak var teamL: UILabel!
    @IBOutlet weak var pP: UILabel!
    @IBOutlet weak var aR: UILabel!
    @IBOutlet weak var pR: UILabel!
    
    
    @IBOutlet weak var roleLabel: UILabel!
    
    
    
    var userData : DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        userData = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
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
            
            if staff == true { self.roleLabel.text = "Staff" }
            if admin == true { self.roleLabel.text = "ADMIN"}
            
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
            self.loadData()
            
            
        })
        
        prayerButton.layer.cornerRadius = 10
        prayerButton.layer.masksToBounds = true
        defsButton.layer.cornerRadius = 10
        defsButton.layer.masksToBounds = true
        reqsButton.layer.cornerRadius = 10
        reqsButton.layer.masksToBounds = true
        compButton.layer.cornerRadius = 10
        compButton.layer.masksToBounds = true
        settings.layer.cornerRadius = 10
        settings.layer.masksToBounds = true
        rR.layer.cornerRadius = 10
        rR.layer.masksToBounds = true
        
        aPView.layer.cornerRadius = aPView.frame.width / 2
        pPView.layer.cornerRadius = pPView.frame.width / 2
        teamView.layer.cornerRadius = teamView.frame.width / 2
        aPView.layer.masksToBounds = true
        pPView.layer.masksToBounds = true
        teamView.layer.masksToBounds = true
        
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        
       
    }


    func loadData() {
        image.sd_setImage(with: URL(string: firstView.userStats.url), completed: nil)
        uName.text = firstView.userStats.userName
        sName.text = firstView.userStats.sName
        aP.text = "\(firstView.userStats.aPoints)"
        pP.text = "\(firstView.userStats.pPoints)"
        aR.text = firstView.userStats.aRank
        pR.text = firstView.userStats.pRank
        teamL.text = firstView.userStats.team
        
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func rulesClicked(_ sender: Any) {
        seeWeb(url: "https://docs.google.com/document/d/1idi5dugfa5mCzslcTcciGDO4O_QEwlNkG0WZLKrIyy0/edit?usp=sharing")
    }
    
    func seeWeb(url: String) {
        let urlC = URL(string: url)!
        let safari = SFSafariViewController(url: urlC)
        self.present(safari, animated: true, completion: nil)
    }
    
}
