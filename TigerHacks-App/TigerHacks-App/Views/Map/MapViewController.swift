//
//  MapViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var floorSelector: UISegmentedControl!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapTableView: UITableView!
    
    
    
    let testArray = [UIImage(named:"firstFloor"),UIImage(named:"secondFloor"),UIImage(named:"thirdFloor")]
    
    let myCalendar = Calendar.current
    
    
    var floorOneEvents:[Event]?
    var floorTwoEvents:[Event]?
    var floorThreeEvents:[Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapTableView.dataSource = self
        mapTableView.delegate = self
        mapImageView.image = testArray[floorSelector.selectedSegmentIndex]
        
        
        
        
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
        
        floorOneEvents = [Event(time: myCalendar.date(from: dateComponents)!,location: "Time Capsule", title: "Game Party",description: "Hanging out and playing games"),
                          Event(time: myCalendar.date(from: dateComponents1)!,location: "Time Capsule", title: "Lunch",description: "Hanging out and playing games")]
        
        floorTwoEvents = [Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway", title: "Dinner",description: "Eating dinner"),
                          Event(time: myCalendar.date(from: dateComponents1)!,location: "Main Hallway", title: "Dinner",description: "Eating dinner")]
        floorThreeEvents = [Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet", title: "Nothin",description: "Don't come"),
                          Event(time: myCalendar.date(from: dateComponents2)!,location: "The Closet", title: "Nothin",description: "Don't come")]
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeLevelOfMap(_ sender: UISegmentedControl) {
        
        mapImageView.image = testArray[sender.selectedSegmentIndex]
        mapTableView.reloadData()
    }
    
    
    
    // MARK: - Tableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events on This Floor"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch floorSelector.selectedSegmentIndex {
        case 0:
            
            return floorOneEvents?.count ?? 0
        case 1:
            
            return floorTwoEvents?.count ?? 0
        case 2:
            
            return floorThreeEvents?.count ?? 0
        default :
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        
        switch floorSelector.selectedSegmentIndex {
            case 0:
                cell.eventLabel.text = floorOneEvents?[indexPath.row].title ?? ""
                cell.locationLabel.text = floorOneEvents?[indexPath.row].location ?? ""
                cell.timeLabel.text = dateFormatter.string(from: floorOneEvents![indexPath.row].time)
            case 1:
                cell.eventLabel.text = floorTwoEvents?[indexPath.row].title ?? ""
                cell.locationLabel.text = floorTwoEvents?[indexPath.row].location ?? ""
                cell.timeLabel.text = dateFormatter.string(from: floorTwoEvents![indexPath.row].time)
            case 2:
                cell.eventLabel.text = floorThreeEvents?[indexPath.row].title ?? ""
                cell.locationLabel.text = floorThreeEvents?[indexPath.row].location ?? ""
                cell.timeLabel.text = dateFormatter.string(from: floorThreeEvents![indexPath.row].time)
            default:
                cell.eventLabel.text = "There is NO Event"
                cell.locationLabel.text = "Who Knows Where"
                cell.timeLabel.text = "No Time"
        }
        
        
        return cell
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
