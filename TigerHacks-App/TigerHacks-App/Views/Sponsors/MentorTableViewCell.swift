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
    @IBOutlet weak var contactButton: UIButton!
    
    weak var delegate: MentorCellDelegate?
    
    @IBAction func contactButtonTapped(_ sender: UIButton) {
        delegate?.mentorTableViewCellDidTapContact(self)
    }

}

protocol MentorCellDelegate: class {
    func mentorTableViewCellDidTapContact(_ sender: MentorTableViewCell)
}
