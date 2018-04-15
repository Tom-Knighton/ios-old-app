//
//  mainSignUp.swift
//  Gary Portal
//
//  Created by Tom Knighton on 02/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import AAPhotoCircleCrop
import AZDialogView
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class mainSignUp: UITableViewController, UIImagePickerControllerDelegate, AACircleCropViewControllerDelegate, UINavigationControllerDelegate {
    
    var userData : DatabaseReference!
    var userStorage : StorageReference!
    let imagePicker = UIImagePickerController()
    
    func circleCropDidCropImage(_ image: UIImage) {
        displayPP.image = image
        setPP.titleLabel?.text = ""
        
    }
    
    func circleCropDidCancel() {
        print("canceled")
    }
    

    @IBOutlet weak var displayPP: UIImageView!
    @IBOutlet weak var setPP: UIButton!
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var emailField: KaedeTextField!
    @IBOutlet weak var passField: KaedeTextField!
    @IBOutlet weak var confirmField: KaedeTextField!
    @IBOutlet weak var fullName: KaedeTextField!
    @IBOutlet weak var schoolField: KaedeTextField!
    @IBOutlet weak var birthField: KaedeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage().reference(forURL: "gs://gary-portal.appspot.com")
        userData = Database.database().reference()
        userStorage = storage.child("users")
        if displayPP.image != nil {
            setPP.titleLabel?.text = ""
        }
        imagePicker.delegate = self
        
        emailField.layer.cornerRadius = 10
        passField.layer.cornerRadius = 10
        confirmField.layer.cornerRadius = 10
        fullName.layer.cornerRadius = 10
        schoolField.layer.cornerRadius = 10
        birthField.layer.cornerRadius = 10
        setPP.layer.cornerRadius = 10
        displayPP.layer.cornerRadius = displayPP.frame.width / 2
        setPP.layer.cornerRadius = setPP.frame.width / 2
        signUp.layer.cornerRadius = 10
        
        emailField.layer.masksToBounds = true
        passField.layer.masksToBounds = true
        confirmField.layer.masksToBounds = true
        fullName.layer.masksToBounds = true
        schoolField.layer.masksToBounds = true
        birthField.layer.masksToBounds = true
        setPP.layer.masksToBounds = true
        signUp.layer.masksToBounds = true
        
        displayPP.layer.masksToBounds = true
        setPP.layer.masksToBounds = true
        
        displayPP.layer.borderWidth = 2
        displayPP.layer.borderColor = UIColor.gray.cgColor
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        self.dismiss(animated: true, completion: {
            let circleCropper = AACircleCropViewController()
            circleCropper.delegate = self
            circleCropper.image = chosenImage
            self.present(circleCropper, animated: true, completion: nil)
        })
        
    }
    func library() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func settingPP(_ sender: Any) {
        if displayPP.image != nil {
            setPP.titleLabel?.text = ""
        }
        let option = AZDialogViewController(title: "Camera or Gallery?", message: "Select where to set you profile image from")
        
        option.addAction(AZDialogAction(title: "Photo Library", handler: { (action) -> (Void) in
            option.dismiss(animated: true,completion: {
                self.library()
            })
        }))
        option.addAction(AZDialogAction(title: "Camera", handler: { (action) -> (Void) in
            self.camera()
        }))
        self.present(option, animated: false, completion: nil)
    }
    @IBAction func signUp(_ sender: Any) {
        var canCreate = true
        
        if emailField.hasText != true || passField.hasText != true || confirmField.hasText != true || fullName.hasText != true || schoolField.hasText != true || birthField.hasText != true {
            
            canCreate = false
            let error = AZDialogViewController(title: "Error", message: "You must enter information into all fields!")
            error.allowDragGesture = true
            error.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                error.dismiss(animated: true, completion: nil)
            }))
            self.present(error, animated: false, completion: nil)
        }
        
        if displayPP.image == nil {
            canCreate = false
            let error = AZDialogViewController(title: "Error", message: "You must set a profile picture!")
            error.allowDragGesture = true
            error.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                error.dismiss(animated: true, completion: nil)
            }))
            self.present(error, animated: false, completion: nil)
        }
        
        
        
        if canCreate == true {
        
            Auth.auth().createUser(withEmail: emailField.text!, password: passField.text!, completion: { (user, error) in
                if let error = error {
                    let errorA = AZDialogViewController(title: "Error", message: error.localizedDescription)
                    errorA.allowDragGesture = true
                    errorA.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                        errorA.dismiss(animated: true, completion: nil)
                    }))
                    self.present(errorA, animated: false, completion: nil)
                } else {
                    let imageRef = self.userStorage.child("\(user!.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.displayPP.image!, 0.5)
                    
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, errorT) in
                        if errorT != nil {
                            let errorA = AZDialogViewController(title: "Error", message: errorT?.localizedDescription)
                            errorA.allowDragGesture = true
                            errorA.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                                errorA.dismiss(animated: true, completion: nil)
                            }))
                            self.present(errorA, animated: false, completion: nil)
                        } else {
                            
                            imageRef.downloadURL(completion: { (url, error3) in
                                if error3 != nil {
                                    let errorA = AZDialogViewController(title: "Error", message: error3?.localizedDescription)
                                    errorA.allowDragGesture = true
                                    errorA.addAction(AZDialogAction(title: "OK", handler: { (action) -> (Void) in
                                        errorA.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(errorA, animated: false, completion: nil)
                                } else {
                                    
                                    if let url = url {
                                        let info : [String: Any] = ["fullName":self.fullName.text!, "email": self.emailField.text!, "password": self.passField.text!, "aRank": "Civilian", "pRank": "Civilian", "team": "Q", "standing": "TBD", "aPoints": 12, "pPoints": 12, "staff": false, "admin": false, "banned": false, "bannedR": "", "chatBan": false, "simplePrayers": 0, "complexPrayers": 0, "queued": true, "uid": user!.uid, "urlToImage": url.absoluteString, "sName": "TBA"]
                                        
                                        self.userData.child("users").child(user!.uid).setValue(info)
                                        self.performSegue(withIdentifier: "signToQueued", sender: self)
                                    }
                                }
                            })
                        
                            
                            
                            
                            
                        }
                    })
                    uploadTask.resume()
                    
                    
                    
                    
                }
            })
        }
    }
    
    
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

}
