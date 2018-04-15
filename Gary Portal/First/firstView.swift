//
//  firstView.swift
//  Gary Portal
//
//  Created by Tom Knighton on 02/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Pastel

class firstView: UIViewController {
    
    public struct userStats {
        
        static var userName = ""
        static var sName = ""
        static var aPoints = 0
        static var pPoints = 0
        static var url = ""
        static var team = ""
        static var aRank = ""
        static var pRank = ""
        static var staff = false
        static var admin = false
        static var id = ""
        static var uid = ""
    }
    
    var userData : DatabaseReference!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .topLeft
        pastelView.endPastelPoint = .bottomRight
        pastelView.animationDuration = 4.0
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        if Auth.auth().currentUser != nil {
            
            userData = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
            userData.observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as! NSDictionary
                var isFree = true
                
                userStats.aPoints = dict["aPoints"] as? Int ?? 0
                userStats.pPoints = dict["pPoints"] as? Int ?? 0
                userStats.aRank = dict["aRank"] as? String ?? ""
                userStats.pRank = dict["pRank"] as? String ?? ""
                userStats.url = dict["urlToImage"] as? String ?? ""
                userStats.team = dict["team"] as? String ?? ""
                userStats.userName = dict["fulName"] as? String ?? ""
                userStats.sName = dict["sName"] as? String ?? ""
                userStats.staff = dict["staff"] as? Bool ?? false
                userStats.admin = dict["admin"] as? Bool ?? false
                userStats.id = dict["id"] as? String ?? ""
                userStats.uid = dict["uid"] as? String ?? ""
                if dict["queued"] as? Bool ?? true == true {
                    print("firstToQueue")
                    self.performSegue(withIdentifier: "firstToQueue", sender: self)
                    isFree = false
                }
                
                if dict["banned"] as? Bool ?? false == true {
                    print("firstToBanned")
                    self.performSegue(withIdentifier: "firstToBanned", sender: self)
                    isFree = false
                }
                
                if isFree == true {
                    print("firstToMain")
                    self.performSegue(withIdentifier: "firstToMain", sender: self)
                }
                
            })
            
        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore == true && Auth.auth().currentUser != nil{
            print("launched before")
            self.performSegue(withIdentifier: "firstToMain", sender: self)
        } else {
            print("not launched")
            self.performSegue(withIdentifier: "firstToQueue", sender: self)
            
        }

    }

   

}
