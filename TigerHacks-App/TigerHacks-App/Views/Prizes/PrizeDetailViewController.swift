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
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var titleText:String?
    var rewardText:String?
    var descriptionText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navItem.title = titleText
        rewardLabel.text = "Reward: \(rewardText ?? "There is no reward. Personally I wouldn't try for this prize...")"
        descriptionLabel.text = "Description: \(descriptionText ?? "There is no description. Weird, somebody probably should've provided a description")"
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
