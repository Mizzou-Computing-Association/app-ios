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
    @IBOutlet weak var prizeTypeSwitcher: UISegmentedControl!
    
    let testBeginnerPrizes = [
                      Prize(sponsor: Sponsor(mentors: nil,name: "Cerner",description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",website: "Cerner.com",location: "Table 6, Main Hallway"),
                            title: "Beginner Prize",
                            reward: "Nothing",
                            description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                            prizeType: PrizeType.beginner),
                      Prize(sponsor: Sponsor(mentors: nil,name: "Cerner",description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",website: "Cerner.com",location: "Table 6, Main Hallway"),
                            title: "Beginner Prize",
                            reward: "Something",
                            description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                            prizeType: PrizeType.beginner)]
    
    let testMainPrizes = [
                              Prize(sponsor: Sponsor(mentors: nil,name: "Cerner",description: "we make healthcare stuff that is good and makes people not die probably most of the time this just to get to a length of more than one line",website: "Cerner.com",location: "Table 6, Main Hallway"),
                                    title: "Make the World Better for us",
                                    reward: "4 trips to a Cerner sponsored hospital facility",
                                    description: "This prize is awarded to the hack that best encompasses Cerner's mission statement to make the world a worse place for developers",
                                    prizeType: PrizeType.main),
                              Prize(sponsor: Sponsor(mentors: nil,name: "RJI",description: "we write articles blah blah blah",website: "Cerner.com",location: "Table 7, Main Hallway"),
                                    title: "Do Something for the J School",
                                    reward: "A big ol' drone",
                                    description: "You better do this one",
                                    prizeType: PrizeType.main),
                              Prize(sponsor: Sponsor(mentors: nil,name: "Google",description: "we google stuff but really its just bing",website: "google.com/careers",location: "Table 99, Main Hallway"),
                                    title: "Snooping For Google",
                                    reward: "A google home wink wink",
                                    description: "This prize is awarded to the hack that best encompasses Google's mission statement to farm as much information about literally everyone",
                                    prizeType: PrizeType.main),
                              Prize(sponsor: Sponsor(mentors: nil,name: "Microsoft",description: "we search stuff but also computers. Really everything",website: "microsoft.com/careers",location: "Table 10, Main Hallway"),
                                    title: "Figure out PageRank",
                                    reward: "We'll hire you",
                                    description: "This prize is awarded to the hack that best figures out how the hell Google is ranking all those pages",
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
        
        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
            return testMainPrizes.count
        }
        else {
            
            return testBeginnerPrizes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
    
        
        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
            cell.prizeTitle.text = testMainPrizes[indexPath.row].title
            cell.prizeReward.text = testMainPrizes[indexPath.row].reward
        }
        else {
            
            cell.prizeTitle.text = testBeginnerPrizes[indexPath.row].title
            cell.prizeReward.text = testBeginnerPrizes[indexPath.row].reward
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "prizeSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PrizeDetailViewController
        let selectedRow = prizeTableView.indexPathForSelectedRow
        
        //Assign values to any outlets in Prize Detail Below
        
        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
            destination.descriptionText = testMainPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testMainPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testMainPrizes[selectedRow?.row ?? 0].reward
        }
        else {
            destination.descriptionText = testBeginnerPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testBeginnerPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testBeginnerPrizes[selectedRow?.row ?? 0].reward
        }
        
        
    }
    

    @IBAction func changeSection(_ sender: UISegmentedControl) {
        //prizeTableView.reloadData()
        //numberOfSections(in: prizeTableView)
        
//        var mainPrizeCount = 0
//        var beginnerPrizeCount = 0
//
//        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
//            for prize in testMainPrizes {
//                if prize.prizeType == PrizeType.main {
//                    mainPrizeCount += 1
//                }
//            }
////            for prize in 0...mainPrizeCount {
////                tableView(prizeTableView, cellForRowAt: IndexPath(row:prize,section:prize))
////            }
////            tableView(prizeTableView, numberOfRowsInSection: mainPrizeCount)
//        }
//        else {
//            for prize in testPrizes {
//                if prize.prizeType == PrizeType.beginner {
//                    beginnerPrizeCount += 1
//                }
//            }
////            for prize in 0...beginnerPrizeCount {
////                tableView(prizeTableView, cellForRowAt: IndexPath(row:prize,section:prize))
////            }
//            tableView(prizeTableView, numberOfRowsInSection: beginnerPrizeCount)
//        }
//
       
        
        
        
        DispatchQueue.main.async{
            self.prizeTableView.reloadData()
        }
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
