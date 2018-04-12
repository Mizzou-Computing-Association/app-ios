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
    
    var testDayOneArray: [Event] = []
    var testDayTwoArray: [Event] = []
    var testDayThreeArray: [Event] = []
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: move api calls to somewhere better probably
        Model.sharedInstance.fakeAPICall()

        testDayOneArray = Model.sharedInstance.dayOneSchedule!
        testDayTwoArray = Model.sharedInstance.dayTwoSchedule!
        testDayThreeArray = Model.sharedInstance.dayThreeSchedule!
        scheduleTableView.reloadData()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
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
        
        switch daySwitcher.selectedSegmentIndex {
            case 0:
                cell.eventLabel.text = testDayOneArray[indexPath.row].title
                cell.locationLabel.text = testDayOneArray[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: testDayOneArray[indexPath.row].time)
            case 1:
                cell.eventLabel.text = testDayTwoArray[indexPath.row].title
                cell.locationLabel.text = testDayTwoArray[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: testDayTwoArray[indexPath.row].time)
            case 2:
                cell.eventLabel.text = testDayThreeArray[indexPath.row].title
                cell.locationLabel.text = testDayThreeArray[indexPath.row].location
                cell.timeLabel.text = dateFormatter.string(from: testDayThreeArray[indexPath.row].time)
            default:
                cell.eventLabel.text = "There is NO Event"
                cell.locationLabel.text = "Who Knows Where"
                cell.timeLabel.text = "No Time"
        }
        
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
        let destination = segue.destination as! EventDetailViewController
        let selectedRow = scheduleTableView.indexPathForSelectedRow
        
        //Assign Values to any outlets in Event Detail
        
        switch daySwitcher.selectedSegmentIndex {
        case 0:
            destination.titleText = testDayOneArray[selectedRow?.row ?? 0].title
            destination.locationText = testDayOneArray[selectedRow?.row ?? 0].location
            destination.timeText = dateFormatter.string(from: testDayOneArray[selectedRow?.row ?? 0].time)
            destination.descriptionText = testDayOneArray[selectedRow?.row ?? 0].description
        case 1:
            destination.titleText = testDayTwoArray[selectedRow?.row ?? 0].title
            destination.locationText = testDayTwoArray[selectedRow?.row ?? 0].location
            destination.timeText = dateFormatter.string(from: testDayTwoArray[selectedRow?.row ?? 0].time)
            destination.descriptionText = testDayTwoArray[selectedRow?.row ?? 0].description
        case 2:
            destination.titleText = testDayThreeArray[selectedRow?.row ?? 0].title
            destination.locationText = testDayThreeArray[selectedRow?.row ?? 0].location
            destination.timeText = dateFormatter.string(from: testDayThreeArray[selectedRow?.row ?? 0].time)
            destination.descriptionText = testDayThreeArray[selectedRow?.row ?? 0].description
        default:
            destination.titleText = "No Title"
            destination.locationText = "No Location"
            destination.timeText = "No Time"
            destination.descriptionText = "No Description"
        }
    }

    
}

