//
//  PrizeTableViewCell.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class PrizeTableViewCell: UITableViewCell {

    @IBOutlet weak var prizeTitle: UILabel!
    @IBOutlet weak var prizeReward: UILabel!
    @IBOutlet weak var prizeType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
