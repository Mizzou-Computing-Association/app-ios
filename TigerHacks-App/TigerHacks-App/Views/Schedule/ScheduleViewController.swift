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
        let myCalendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.day = 12
        dateComponents.hour = 20
        dateComponents.minute = 30
        var dateComponents1 = DateComponents()
        dateComponents1.day = 13
        dateComponents1.hour = 12
        dateComponents1.minute = 00
        var dateComponents2 = DateComponents()
        dateComponents2.day = 14
        dateComponents2.hour = 8
        dateComponents2.minute = 30
        
        
        let testDayOneArray = [Event(time: myCalendar.date(from: dateComponents)!,location: "Time Capsule",floor: 1, title: "Game Party",description: "Hanging out and playing games"),
                               Event(time: myCalendar.date(from: dateComponents1)!,location: "Time Capsule",floor: 1, title: "Lunch",description: "Hanging out and playing games"),
                               Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway",floor: 2, title: "Dinner",description: "Eating dinner"),
                               Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway",floor: 2, title: "Dinner",description: "Eating dinner"),
                               Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet",floor: 3, title: "Nothin",description: "Don't come"),
                               Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet",floor: 3, title: "Nothing happens on this floor I promise  Nothing happens on this floor I promise  Nothing happens on this floor I promise",description: "Don't come")]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell1", for: indexPath) as! ScheduleTableViewCell
        cell.eventNameLabel.text = testDayOneArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "scheduleEventDetail", sender: self)
    }
    

    @IBAction func changeDay(_ sender: UISegmentedControl) {
        scheduleTableView.reloadData()
    }
    
    
 
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    
}

