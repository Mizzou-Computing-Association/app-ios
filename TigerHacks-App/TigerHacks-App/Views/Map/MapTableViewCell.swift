//
//  MapTableViewCell.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/13/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
