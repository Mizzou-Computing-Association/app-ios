//
//  PrizesViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class PrizesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var prizeTableView: UITableView!
    
    let testPrizes = [Prize(sponsor: Sponsor(mentors: nil,name: "Cerner",description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",website: "Cerner.com",location: "Table 6, Main Hallway"),
                            title: "Cerner Make the World Better Prize",
                            reward: "4 trips to a Cerner sponsored hospital facility",
                            description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                            prizeType: PrizeType.main)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.prizeTableView.rowHeight = 80;
        prizeTableView.delegate = self
        prizeTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testPrizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
        
        cell.prizeTitle.text = testPrizes[indexPath.row].title
        cell.prizeReward.text = testPrizes[indexPath.row].reward
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "prizeSegue", sender: self)
        //Need to ask Shawn how to make it a manual segue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PrizeDetailViewController
        let selectedRow = prizeTableView.indexPathForSelectedRow?.first
        
        //Assign values to any outlets in Prize Detail Below
        destination.descriptionText = testPrizes[selectedRow!].description
        destination.titleText = testPrizes[selectedRow!].title
        destination.rewardText = testPrizes[selectedRow!].reward
        
        destination.navItem.title = "butts"
//        if let row = selectedRow{
//            destination.image = imageArray[row]
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
    @IBAction func changeSection(_ sender: UISegmentedControl) {
        
    }
    
}
