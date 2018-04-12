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
    
    var testBeginnerPrizes = [Prize]()
    var testMainPrizes = [Prize]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.sharedInstance.fakeAPICall()
        testBeginnerPrizes = Model.sharedInstance.beginnerPrizes!
        testMainPrizes = Model.sharedInstance.mainPrizes!
        
        self.prizeTableView.rowHeight = 80;
        prizeTableView.delegate = self
        prizeTableView.dataSource = self
        
        prizeTableView.rowHeight = UITableViewAutomaticDimension
        prizeTableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
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
    

    // MARK: - Reloading of Sections

    @IBAction func changeSection(_ sender: UISegmentedControl) {
   
        DispatchQueue.main.async{
            self.prizeTableView.reloadData()
        }
    }
    
    
     // MARK: - Navigation
     

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PrizeDetailViewController
        let selectedRow = prizeTableView.indexPathForSelectedRow
        
        //Assign values to any outlets in Prize Detail
        
        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
            destination.sponsor = testMainPrizes[selectedRow?.row ?? 0].sponsor
            destination.descriptionText = testMainPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testMainPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testMainPrizes[selectedRow?.row ?? 0].reward
        }
        else {
            destination.sponsor = testBeginnerPrizes[selectedRow?.row ?? 0].sponsor
            destination.descriptionText = testBeginnerPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testBeginnerPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testBeginnerPrizes[selectedRow?.row ?? 0].reward
        }
    }
    
}
