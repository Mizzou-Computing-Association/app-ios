//
//  MentorTableViewCell.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/10/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class MentorTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var mentorNameLabel: UILabel!
    @IBOutlet weak var mentorSkillsLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
