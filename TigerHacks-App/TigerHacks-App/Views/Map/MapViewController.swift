//
//  MapViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var floorSelector: UISegmentedControl!
    @IBOutlet weak var mapImageView: UIImageView!
    
    let testArray = [UIImage(named:"linkedInPhoto"),UIImage(named:"sherduck"),UIImage(named:"waterPoloBall")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapImageView.image = testArray[floorSelector.selectedSegmentIndex]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeLevelOfMap(_ sender: UISegmentedControl) {
        
        
        mapImageView.image = testArray[sender.selectedSegmentIndex]
        
//        switch sender.selectedSegmentIndex {
//        case 0:
//            mapImageView.image = testArray
//        case 1:
//
//        case 2:
//
//        default:
//            <#code#>
//        }
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
