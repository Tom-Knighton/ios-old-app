//
//  commentCell.swift
//  Gary Portal
//
//  Created by Tom Knighton on 06/03/2018.
//  Copyright © 2018 Tom Knighton. All rights reserved.
//

import UIKit
import MGSwipeTableCell
class commentCell: MGSwipeTableCell {

    @IBOutlet weak var commenterURL: UIImageView!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
