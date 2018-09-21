//
//  PrizesViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.
//

import UIKit

class PrizesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var prizeTableView: UITableView!
    @IBOutlet weak var prizeTypeSwitcher: UISegmentedControl!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!

    var testBeginnerPrizes = [Prize]()
    var testMainPrizes = [Prize]()

    var favoriteBeginnerPrizes = [Prize]()
    var favoriteMainPrizes = [Prize]()

    var refreshControl: UIRefreshControl!
    
    var favorited = false
    
    let favoriteIconImage = UIImage(named: "favorite")
    let favoriteSelectedIconImage = UIImage(named: "favorite_selected")
    var favoriteButton: UIButton?

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
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        // Refresh Control

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        prizeTableView.addSubview(refreshControl)
        
        // Favorites
        
        setupFavoriteBarButtonItem()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// MARK: - Loading Prizes

    func loadPrizes() {
        testBeginnerPrizes = Model.sharedInstance.beginnerPrizes!
        testMainPrizes = Model.sharedInstance.mainPrizes!
    }

    @objc func refresh(_ sender: Any) {
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

// MARK: - Nav Bar Gradient

    func setUpNavBar() {
        Model.sharedInstance.setBarGradient(navigationBar: (navigationController?.navigationBar)!)
        //Tab bar
        tabBarController?.tabBar.backgroundImage = Model.sharedInstance.setGradientImageTabBar()
        tabBarController?.tabBar.shadowImage =  UIImage()
    }

// MARK: - Favorites

    @IBAction func toggleFavorites(_ sender: UIBarButtonItem) {
        if favoriteBarButtonItem.image == UIImage(named: "favorite_selected") {
            favoriteBarButtonItem.image = UIImage(named: "favorite")
            prizeTableView.reloadData()
        }else {
            favoriteBarButtonItem.image = UIImage(named: "favorite_selected")
            prizeTableView.reloadData()
        }
    }
    
// Mark: - Favorite Button Animation
    
    @objc func tappedFavoriteButton(){
        toggleFavorited()
    }
    
    func setupFavoriteBarButtonItem() {
        guard let size = favoriteIconImage?.size else {
            return
        }
        
        let favoriteIconRect = CGRect(origin: CGPoint.zero, size: size)
        favoriteButton = UIButton(frame: favoriteIconRect)
        favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)
        favoriteButton?.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchUpInside)
        if let favoriteButton = favoriteButton {
            favoriteBarButtonItem.customView = favoriteButton
        }
    }
    
    func toggleFavorited() {
        if (favorited) {
            favorited = false
            favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)

        } else {
            favorited = true
            favoriteButton?.setBackgroundImage(favoriteSelectedIconImage, for: .normal)
        }
        favoriteButton?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.favoriteButton?.transform = CGAffineTransform.identity
        }, completion: {
            (result) in
            print("favorite was tapped and the animation happened")
        })
    }
    

// MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if favoriteBarButtonItem.image == UIImage(named: "favorite") {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                return testMainPrizes.count
            } else {
                return testBeginnerPrizes.count
            }
        } else {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                return favoriteMainPrizes.count
            } else {
                return favoriteBeginnerPrizes.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
    
        if favoriteBarButtonItem.image == UIImage(named: "favorite") {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                cell.prizeTitle.text = testMainPrizes[indexPath.row].title
                cell.prizeReward.text = testMainPrizes[indexPath.row].reward
            } else {
                cell.prizeTitle.text = testBeginnerPrizes[indexPath.row].title
                cell.prizeReward.text = testBeginnerPrizes[indexPath.row].reward
            }
        } else {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                cell.prizeTitle.text = favoriteMainPrizes[indexPath.row].title
                cell.prizeReward.text = favoriteMainPrizes[indexPath.row].reward
            } else {
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
        } else {
            destination.sponsor = testBeginnerPrizes[selectedRow?.row ?? 0].sponsor
            destination.descriptionText = testBeginnerPrizes[selectedRow?.row ?? 0].description
            destination.titleText = testBeginnerPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = testBeginnerPrizes[selectedRow?.row ?? 0].reward
            destination.typeText = "Beginner"
        }
    }
}
