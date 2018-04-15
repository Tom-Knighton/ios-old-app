//
//  settingsView.swift
//  Gary Portal
//
//  Created by Tom Knighton on 18/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import AZDialogView
class settingsView: UIViewController {

    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var compactSwitch: UISwitch!
    @IBOutlet weak var infoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let standards = UserDefaults.standard
        if standards.bool(forKey: "compactGary") == true {
            self.compactSwitch.isOn = true
        } else {
            self.compactSwitch.isOn = false
        }
        infoButton.layer.cornerRadius = 20
        infoButton.layer.masksToBounds = true
        
        let path = UIBezierPath(roundedRect: screen.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        screen.layer.mask = maskLayer

        
    }

    @IBAction func infoPressed(_ sender: Any) {
        let alert = AZDialogViewController(title: "Gary Portal", message: "App Version: 3.0.0\nDevelopers: Tom K, Rateee🐀 \nInteresting Fact: A crocodile can't poke its tongue out :P\n\nMade in Heaven")
        alert.imageHandler = { (imageView) in
            imageView.image = UIImage(named: "icon")
            imageView.contentMode = .scaleAspectFill
            return true
        }
        self.present(alert, animated: false, completion: nil)
    }
    @IBAction func switchChanged(_ sender: UISwitch) {
        if compactSwitch.isOn {
            let user = UserDefaults.standard
            user.set(true, forKey: "compactGary")
        } else {
            let user = UserDefaults.standard
            user.set(false, forKey: "compactGary")
        }
    }
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @IBAction func swiped(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
