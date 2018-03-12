//
//  PrizeDetailViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class PrizeDetailViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sponsorSubview: UIView!
    @IBOutlet weak var rewardSubview: UIView!
    @IBOutlet weak var descriptionSubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineBreakSubview: UIView!
    
    var sponsor:Sponsor?
    var titleText:String?
    var rewardText:String?
    var descriptionText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.bringSubview(toFront: rewardLabel)
        sponsorSubview.clipsToBounds = true
        rewardSubview.clipsToBounds = true
        descriptionSubview.clipsToBounds = true
        lineBreakSubview.clipsToBounds = true
        
        sponsorSubview.layer.cornerRadius = 20
        rewardSubview.layer.cornerRadius = 20
        descriptionSubview.layer.cornerRadius = 20
        lineBreakSubview.layer.cornerRadius = 20
        
        sponsorSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        rewardSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        descriptionSubview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        titleLabel.text = titleText
        sponsorLabel.text = "\(sponsor?.name ?? "This isn't a sponsored prize")"
        rewardLabel.text = "\(rewardText ?? "There is no reward. Personally I wouldn't try for this prize...")"
        descriptionLabel.text = "\(descriptionText ?? "There is no description. Weird, somebody probably should've provided a description")"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
