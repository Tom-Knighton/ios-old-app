//
//  poll.swift
//  Gary Portal
//
//  Created by Tom Knighton on 17/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit

class poll : NSObject {
    var posterName : String?
    var posterURL : String?
    var question : String?
    var opt1 : String?
    var opt2 : String?
    var votes1 : Int?
    var votes2 : Int?
    var totalVotes : Int?
    var hasVoted : Bool?
    var canVote : Bool?
    var posterID : String?
}
