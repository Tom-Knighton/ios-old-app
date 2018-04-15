//
//  stringTrim.swift
//  Gary Portal
//
//  Created by Tom Knighton on 06/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}

