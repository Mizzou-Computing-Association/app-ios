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
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    var testBeginnerPrizes = [Prize]()
    var testMainPrizes = [Prize]()
    
    var favoriteBeginnerPrizes = [Prize]()
    var favoriteMainPrizes = [Prize]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Setup
        
        setUpNavBar()
        prizeTableView.delegate = self
        prizeTableView.dataSource = self
        Model.sharedInstance.fakeAPICall()
        loadPrizes()
        
        // Swipe to change level
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Refresh Control
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        prizeTableView.addSubview(refreshControl)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: - Loading Prizes
    
    func loadPrizes() {
        testBeginnerPrizes = Model.sharedInstance.beginnerPrizes!
        testMainPrizes = Model.sharedInstance.mainPrizes!
    }
    
    @objc func refresh(_ sender:Any) {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadPrizes()
            self.refreshControl.endRefreshing()
            self.prizeTableView.reloadData()
        }
    }
    
// MARK: - Change Sections
    
    @IBAction func changeSection(_ sender: UISegmentedControl) {
        self.prizeTableView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else {return}
        
        switch swipeGesture.direction {
        case .left:
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                prizeTypeSwitcher.selectedSegmentIndex = 1
            }
        case .right:
            if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                prizeTypeSwitcher.selectedSegmentIndex = 0
            }
        default:
            break
        }
        prizeTableView.reloadData()
    }
    
//MARK: - Nav Bar Gradient
    
    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
    }
    
//MARK: - Favorites
    
    @IBAction func toggleFavorites(_ sender: UIBarButtonItem) {
        if favoritesButton.image == UIImage(named: "favoriteStar") {
            favoritesButton.image = UIImage(named: "unfavoriteStar")
            prizeTableView.reloadData()
        }else {
            favoritesButton.image = UIImage(named: "favoriteStar")
            prizeTableView.reloadData()
        }
    }
       
// MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favoritesButton.image == UIImage(named: "unfavoriteStar") {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                return testMainPrizes.count
            }
            else {
                return testBeginnerPrizes.count
            }
        }else {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                return favoriteMainPrizes.count
            }
            else {
                return favoriteBeginnerPrizes.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
    
        if favoritesButton.image == UIImage(named: "unfavoriteStar") {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                cell.prizeTitle.text = testMainPrizes[indexPath.row].title
                cell.prizeReward.text = testMainPrizes[indexPath.row].reward
            }
            else {
                cell.prizeTitle.text = testBeginnerPrizes[indexPath.row].title
                cell.prizeReward.text = testBeginnerPrizes[indexPath.row].reward
            }
        }else {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                cell.prizeTitle.text = favoriteMainPrizes[indexPath.row].title
                cell.prizeReward.text = favoriteMainPrizes[indexPath.row].reward
            }
            else {
                cell.prizeTitle.text = favoriteBeginnerPrizes[indexPath.row].title
                cell.prizeReward.text = favoriteBeginnerPrizes[indexPath.row].reward
            }
        }
        return cell
    }
    

// MARK: - Segues
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "prizeSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PrizeDetailViewController
        let selectedRow = prizeTableView.indexPathForSelectedRow
        
        //Assign values to any outlets in Prize Detail
        
        if prizeTypeSwitcher.selectedSegmentIndex == 0 {
            destination.sponsor = testMainPrizes[selectedRow?.row ?? 0].sponsor
            destination.descriptionText = testMainPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testMainPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testMainPrizes[selectedRow?.row ?? 0].reward
            destination.typeText = "Main"
        }
        else {
            destination.sponsor = testBeginnerPrizes[selectedRow?.row ?? 0].sponsor
            destination.descriptionText = testBeginnerPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testBeginnerPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testBeginnerPrizes[selectedRow?.row ?? 0].reward
            destination.typeText = "Beginner"
        }
    }
}
