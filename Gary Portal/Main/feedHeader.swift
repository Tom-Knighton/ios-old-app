
//
//  feedHeader.swift
//  Gary Portal
//
//  Created by Tom Knighton on 04/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit

class feedHeader: UIViewController {

    @IBOutlet weak var screen: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = UIBezierPath(roundedRect: screen.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        screen.layer.mask = maskLayer
    }

   

}
