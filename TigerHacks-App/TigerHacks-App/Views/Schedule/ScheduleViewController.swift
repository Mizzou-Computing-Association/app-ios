//
//  ScheduleViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var daySwitcher: UISegmentedControl!
    
    let testDayOneArray: [Event] = []
    let testDayTwoArray: [Event] = []
    let testDayThreeArray: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch daySwitcher.selectedSegmentIndex {
        case 0 :
            return testDayOneArray.count
        case 1 :
            return testDayTwoArray.count
        case 2 :
            return testDayThreeArray.count
        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ScheduleTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func changeDay(_ sender: UISegmentedControl) {
        scheduleTableView.reloadData()
    }
    
    
 
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    
}

