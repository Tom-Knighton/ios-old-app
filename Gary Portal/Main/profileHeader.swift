//
//  profileHeader.swift
//  Gary Portal
//
//  Created by Tom Knighton on 02/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import Pastel

class profileHeader: UIViewController {

    @IBOutlet weak var screen: UIView!
    @IBOutlet weak var colBack: UIImageView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = UIBezierPath(roundedRect: screen.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        screen.layer.mask = maskLayer
        
       

    }


}
