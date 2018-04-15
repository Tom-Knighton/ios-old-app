//
//  loginViewController.swift
//  Gary Portal
//
//  Created by Tom Knighton on 01/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import TextFieldEffects
import TOMSMorphingLabel
import IHKeyboardAvoiding
import Firebase
import FirebaseDatabase
import FirebaseAuth
import AZDialogView

protocol nameEdited {
    func name_edited(name: String)
}

class loginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: KaedeTextField!
    @IBOutlet weak var passwordField: KaedeTextField!
    @IBOutlet weak var login: UIButton!
    
    var textBeingEdit = false
    @IBOutlet weak var screen: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        KeyboardAvoiding.avoidingView = screen
        emailField.layer.cornerRadius = 10
        passwordField.layer.cornerRadius = 10
        emailField.layer.masksToBounds = true
        passwordField.layer.masksToBounds = true
        login.layer.cornerRadius = 10
        login.layer.masksToBounds = true
        let path = UIBezierPath(roundedRect: screen.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        screen.layer.mask = maskLayer
    }
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var delegate: nameEdited?

    func name_edited(name: String) {
        delegate?.name_edited(name: name)
    }

    @IBAction func swipeGet(_ sender: UIPanGestureRecognizer) {
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
    
    @IBAction func loginPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        if emailField.hasText != true || passwordField.hasText != true {
            let error = AZDialogViewController(title: "Error", message: "You have to enter an email and password to login!")
            error.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                error.dismiss()
            }))
            self.present(error, animated: false, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if error != nil {
                    let errorM = AZDialogViewController(title: "Error", message: error?.localizedDescription)
                    errorM.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                        errorM.dismiss()
                    }))
                    self.present(errorM, animated: false, completion: nil)
                } else {
                    
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textBeingEdit = true
        
        if textField.placeholder == "Enter Email" {
            name_edited(name: emailField.text!)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textBeingEdit = false
    }
    
    @IBAction func dismissView(_ sender: Any) {
        if textBeingEdit == false {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
        }
    }
    
}
