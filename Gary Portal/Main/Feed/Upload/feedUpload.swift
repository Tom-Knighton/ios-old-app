//
//  feedUpload.swift
//  Gary Portal
//
//  Created by Tom Knighton on 07/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AZDialogView
import AVFoundation

class feedUpload: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var finishB: UIButton!
    @IBOutlet weak var addDesc: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var imageB: UIButton!
    @IBOutlet weak var descDisplay: UILabel!
    
    var userStorage : StorageReference!
    var userData : DatabaseReference!
    var globalData : DatabaseReference!
    let imagePicker = UIImagePickerController()
    var inputTextField: UITextField?
    
    var isImage : Bool = true
    
    var hasDesc : Bool = false
    var hasImg : Bool = false
    var setDesc : String = ""
    var hasDone : Bool = false
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageB.layer.cornerRadius = 5
        imageB.layer.masksToBounds = true
        
        imageV.layer.cornerRadius = 5
        imageV.layer.masksToBounds = true
        
        addDesc.layer.cornerRadius = 20
        addDesc.layer.masksToBounds = true
        
        finishB.layer.cornerRadius = 20
        finishB.layer.masksToBounds = true
        
        imagePicker.delegate = self
        self.updatePostButton()
        let storage = Storage.storage().reference(forURL: "gs://gary-portal.appspot.com")
        userData = Database.database().reference().child("feed")
        globalData = Database.database().reference().child("globalvariables")
        
        userStorage = storage.child("feed")

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if info[UIImagePickerControllerOriginalImage] is UIImage {
            var chosenImage = UIImage()
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.isImage = true
            
            self.dismiss(animated: true, completion: {
                self.imageV.image = chosenImage
                self.imageB.backgroundColor = UIColor.clear
                self.hasImg = true
                self.updatePostButton()
            })
        } else {
            self.videoURL = info["UIImagePickerControllerMediaURL"] as? URL
            self.dismiss(animated: true, completion: {
                do {
                    self.isImage = false
                    
                    let asset = AVURLAsset(url: self.videoURL! , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                    let thumbnail = UIImage(cgImage: cgImage)
                    self.imageV.image = thumbnail
                    self.hasImg = true
                    self.updatePostButton()
                } catch let error {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
            })
        }
        
        
       
        
    }
    func library() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image", "public.movie"]
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
       
        let option = AZDialogViewController(title: "Camera or Gallery?", message: "Select where to set you profile image from")
        
        option.addAction(AZDialogAction(title: "Photo Library", handler: { (action) -> (Void) in
            option.dismiss(animated: true,completion: {
                self.library()
            })
        }))
        option.addAction(AZDialogAction(title: "Camera", handler: { (action) -> (Void) in
            option.dismiss(animated: true, completion: {
                self.camera()
            })
        }))
        self.present(option, animated: false, completion: nil)
    }
    
    @IBAction func setDesc(_ sender: Any) {
        let descAlert = UIAlertController(title: "Enter Description", message: nil, preferredStyle: .alert)
        descAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            let description = self.inputTextField?.text?.trim()
            if description != "" && description != " " {
                self.setDesc = description!
                self.descDisplay.text = "Description: "+description!
                self.hasDesc = true
                self.updatePostButton()
            } else {
                let noTextA = UIAlertController(title: "Error", message: "Please enter text", preferredStyle: .alert)
                noTextA.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(noTextA, animated: true, completion: nil)
                self.hasDesc = false
                self.setDesc = ""
                self.descDisplay.text = "Description: "
                self.updatePostButton()
            }
        }))
        
        descAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        descAlert.addTextField(configurationHandler:  { (textField) in
            textField.autocorrectionType = .yes
            textField.placeholder = "Description: "
            textField.autocapitalizationType = .sentences
            self.inputTextField = textField
        })
        
        self.present(descAlert, animated: true, completion: nil)
    }
    
    func updatePostButton() {
        if hasDesc == true && hasImg == true {
            self.finishB.isEnabled = true
            self.finishB.backgroundColor = UIColor.purple
        } else {
            self.finishB.isEnabled = false
            self.finishB.backgroundColor = UIColor.gray
        }
    }

    @IBAction func finishPressed(_ sender: Any) {
        self.globalData.queryOrderedByKey().observe(.value, with: {(snapshot) in
            if self.hasDone == false {
                self.hasDone = true
                let dict = snapshot.value as? NSDictionary
                let oldN = dict?["lastPost"] as? Int
                let newN = oldN! - 1
                let uuid = NSUUID().uuidString.lowercased()
                var imageRef = self.userStorage.child("\(uuid).jpg")
                let data = UIImageJPEGRepresentation(self.imageV.image!, 0.5)
                
                if self.isImage == true {
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, nil) in
                        imageRef.downloadURL(completion: { (url, error) in
                            if error != nil {print(error!.localizedDescription)}
                            if let url = url {
                                let postInfo : [String : Any] = ["Comments":1,"Likes":0,"postNum":newN, "posterID":"tomk", "postURL":url.absoluteString, "posterURL":firstView.userStats.url,"desc":self.setDesc,"posterName":firstView.userStats.userName,"type":"image"]
                                self.userData.child("\(newN)").setValue(postInfo)
                                let date = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yy"
                                let dateResult = formatter.string(from: date)
                                
                                let commentInfo : [String:Any] = ["comment":self.setDesc, "date": dateResult, "commenterurl": firstView.userStats.url]
                                self.userData.child("\(newN)").child("commentList").child("1").setValue(commentInfo)
                                self.globalData.child("lastPost").setValue(newN)
                                self.globalData.removeAllObservers()
                                self.finishB.isEnabled = false
                            }
                        })
                    })
                    
                    uploadTask.resume()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    imageRef = self.userStorage.child("videos").child("\(uuid).mov")
                    imageRef.putFile(from: self.videoURL as! URL, metadata: nil, completion : {(metadata, nil) in
                        imageRef.downloadURL(completion: {(url, error) in
                            if error != nil {print(error!.localizedDescription)}
                            if let url = url {
                                let postInfo : [String: Any] = ["Comments": 1, "Likes": 0, "postNum":newN, "posterID":firstView.userStats.id, "postURL":url.absoluteString,"posterURL":firstView.userStats.url, "desc":self.setDesc,"posterName":firstView.userStats.userName,"type":"video"]
                                self.userData.child("\(newN)").setValue(postInfo)
                                let date = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yy"
                                let dateResult = formatter.string(from: date)
                                
                                let commentInfo : [String:Any] = ["comment":self.setDesc, "date": dateResult, "commenterurl": firstView.userStats.url]
                                self.userData.child("\(newN)").child("commentList").child("1").setValue(commentInfo)
                                self.globalData.child("lastPost").setValue(newN)
                                self.globalData.removeAllObservers()
                                self.finishB.isEnabled = false
                            }
                            
                        })
                    })
                    
                }
            }
        })
    }
    

}
