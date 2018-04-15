//
//  mainSwiper.swift
//  Gary Portal
//
//  Created by Tom Knighton on 05/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import EZSwipeController
class mainSwiper: EZSwipeController {
    
    @IBOutlet weak var colBack: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func setupView() {
        datasource = self
    }


}

extension mainSwiper: EZSwipeControllerDataSource {
    
    func newVC(viewController: String) -> UIViewController{
        return UIStoryboard(name: "mainThree", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func viewControllerData() -> [UIViewController] {
        
        return [newVC(viewController: "feedMain"), newVC(viewController: "profileHeader")]
    }
    
    func indexOfStartingPage() -> Int {
        return 1
    }
}
