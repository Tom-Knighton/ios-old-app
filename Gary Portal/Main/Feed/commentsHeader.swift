//
//  feedHeader.swift
//  Gary Portal
//
//  Created by Tom Knighton on 05/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import AZDialogView
import Firebase
import FirebaseDatabase
class commentsHeader: UIViewController {
    var selectedIndex : Int = 0
    var userData : DatabaseReference!
    var postNum : Int = 10000
    var currentComments : Int = 1
    
    @IBOutlet weak var header: UINavigationBar!
    
    
    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var postCommentButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = UIBezierPath(roundedRect: screen.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        header.layer.mask = maskLayer
        
        postNum = feedView.currentNum.postNum
        userData = Database.database().reference().child("feed").child("\(postNum)")
    }

    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    var inputTextField: UITextField?
    func postComment(date: String, comment: String, url: String) {
        userData!.queryOrderedByKey().observe(.value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            let oldN = dict?["Comments"] as? Int ?? 1
            let newN = oldN + 1
            let postInfo : [String : Any] = ["comment": comment, "date": date, "commenterurl": url]
            self.userData!.child("Comments").setValue(newN)
            self.userData!.child("commentList").child("\(newN)").setValue(postInfo)
            
            let comments = self.childViewControllers[0] as? commentsTable
            comments?.loadComments()
            
        })
        userData!.removeAllObservers()
    }
    @IBAction func addComment(_ sender: Any) {
        let alert = UIAlertController(title: "Add Comment", message: "Add a comment below", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Post", style: .default, handler: { (action) in
            print("\(self.inputTextField?.text ?? "")")
            let comment = self.inputTextField?.text?.trim()
            let commenterurl = firstView.userStats.url
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            let dateResult = formatter.string(from: date)
            
            
            if comment != "" && comment != " " {
                self.postComment(date: dateResult, comment: comment! , url: commenterurl)
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField) in
            textField.autocorrectionType = UITextAutocorrectionType.yes
            textField.placeholder = "Comment"
            textField.autocapitalizationType = UITextAutocapitalizationType.sentences
            self.inputTextField = textField
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
