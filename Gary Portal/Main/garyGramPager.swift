//
//  garyGramPager.swift
//  Gary Portal
//
//  Created by Tom Knighton on 04/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
class garyGramPager: UIViewController, TwicketSegmentedControlDelegate {
    var current: Int = 0
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            current = 0
            feedContainer.isHidden = false
        }
        if segmentIndex == 1 {
            current = 1
            feedContainer.isHidden = true
        }
        if segmentIndex == 2 {
            current = 2
            feedContainer.isHidden = true
        }
    }
    
    @IBOutlet weak var uploadB: UIButton!
    
    @IBOutlet weak var twicker: TwicketSegmentedControl!
    @IBOutlet weak var feedContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["GaryGram", "Polls", "ADIT LOGS"]
        twicker.setSegmentItems(titles)
        twicker.delegate = self
        twicker.move(to: 0)
        
        uploadB.layer.cornerRadius = 10
        uploadB.layer.masksToBounds = true
      
    }

    @IBAction func uploadPressed(_ sender: Any) {
        if current == 0 {
            self.performSegue(withIdentifier: "feedToUploadG", sender: self)
        }
    }
    

}
