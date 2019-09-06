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

    var allPrizes = [Prize]()
    var beginnerPrizes = [Prize]()
    var mainPrizes = [Prize]()
    var startUpPrizes = [Prize]()

    var favoritePrizes = [Prize]()

    var refreshControl: UIRefreshControl!
    
    var favorited = false
    
    let favoriteIconImage = UIImage(named: "favorite")
    let favoriteSelectedIconImage = UIImage(named: "favorite_selected")
    var favoriteButton: UIButton?
    
    let prizeTitle = String()
    let defaults = UserDefaults.standard
    var favoritePrizeTitles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial Setup

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavoritedPrizes()
    }

// MARK: - Loading Prizes

    func loadPrizes() {
        Model.sharedInstance.prizeLoad(dispatchQueueForHandler: DispatchQueue.main) {(prizes, errorString) in
            if let errorString = errorString {
                print("Error: \(errorString)")
            } else if let prizes = prizes {
                self.allPrizes = prizes
                print("prizes from vc: \(prizes)")
                var tempPrizes = [Prize]()
                for prize in prizes {
                    let newPrize = Prize(sponsorID: prize.sponsorID, title: prize.title, reward: prize.reward, description: prize.description, prizeType: prize.prizeType)
                    tempPrizes.append(newPrize)
                }
                self.allPrizes = tempPrizes
                self.dividePrizes()
                print("tempPrizes from vc: \(tempPrizes)")
            }
        }
        //self.prizeTableView.reloadData()
    }
    
    func dividePrizes() {
        var tempBeginners = [Prize]()
        var tempMains = [Prize]()
        var tempStartUps = [Prize]()
        
        for prize in allPrizes {
            switch prize.prizeType {
            case .Main:
                tempMains.append(prize)
            case .Beginner:
                tempBeginners.append(prize)
            case .StartUp:
                tempStartUps.append(prize)
            }
        }
        beginnerPrizes = tempBeginners
        mainPrizes = tempMains
        startUpPrizes = tempStartUps
        prizeTableView.reloadData()
    }

    @objc func refresh(_ sender: Any) {
        Model.sharedInstance.fakeAPICall()
        let when = DispatchTime.now() + 0.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadPrizes()
            self.getFavoritedPrizes()
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

        if !favorited {
            switch swipeGesture.direction {
            case .left:
                if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                    prizeTypeSwitcher.selectedSegmentIndex = 1
                } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                    prizeTypeSwitcher.selectedSegmentIndex = 2
                }
            case .right:
                if prizeTypeSwitcher.selectedSegmentIndex == 2 {
                    prizeTypeSwitcher.selectedSegmentIndex = 1
                } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                    prizeTypeSwitcher.selectedSegmentIndex = 0
                }
            default:
                break
            }
            prizeTableView.reloadData()
        }
        
    }

// MARK: - Favorites

    @IBAction func toggleFavorites(_ sender: UIBarButtonItem) {
        toggleFavorited()
    }
    
// MARK: - Favorite Button Animation
    
    @objc func tappedFavoriteButton() {
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
        if favorited {
            favorited = false
            prizeTypeSwitcher.tintColor = view.tintColor
            prizeTypeSwitcher.isEnabled = true
            favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)
            //getFavoritedPrizes()
            prizeTableView.reloadData()

        } else {
            favorited = true
            prizeTypeSwitcher.tintColor = UIColor.gray
            prizeTypeSwitcher.isEnabled = false
            favoriteButton?.setBackgroundImage(favoriteSelectedIconImage, for: .normal)
//            getFavoritedPrizes()
            prizeTableView.reloadData()
            
        }
        favoriteButton?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.favoriteButton?.transform = CGAffineTransform.identity
        }, completion: { (_) in
            print("favorite was tapped and the animation happened")
        })
    }
    
    func getFavoritedPrizes() {
        if let favoritedArray = defaults.array(forKey: "Favorited"),
            let stringFavoritedArray = favoritedArray as? [String] {
            favoritePrizeTitles = stringFavoritedArray
            favoritePrizes = [Prize]()
            for title in favoritePrizeTitles {
                for prize in allPrizes where prize.title == title {
                    for (index, favoritePrize) in favoritePrizes.enumerated() where favoritePrize.title == title {
                        favoritePrizes.remove(at: index)
                    }
                    favoritePrizes.append(prize)
                }
            }
            print("Favorite Prize Titles: \(favoritePrizeTitles)")
            print("Favorite Prizes: \(favoritePrizes)")
            prizeTableView.reloadData()
        }
    }
    
// MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if favorited {
            return favoritePrizes.count
        } else {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                return mainPrizes.count
            } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                return beginnerPrizes.count
            } else {
                return startUpPrizes.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
    
        if !favorited {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                cell.prizeTitle.text = mainPrizes[indexPath.row].title
                cell.prizeReward.text = mainPrizes[indexPath.row].reward
            } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                cell.prizeTitle.text = beginnerPrizes[indexPath.row].title
                cell.prizeReward.text = beginnerPrizes[indexPath.row].reward
            } else {
                cell.prizeTitle.text = startUpPrizes[indexPath.row].title
                cell.prizeReward.text = startUpPrizes[indexPath.row].reward
            }
        } else {
            cell.prizeTitle.text = favoritePrizes[indexPath.row].title
            cell.prizeReward.text = favoritePrizes[indexPath.row].reward
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

        if !favorited {
            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
                //destination.sponsor = testMainPrizes[selectedRow?.row ?? 0].sponsor
                destination.descriptionText = mainPrizes[selectedRow?.row ?? 0].description
                destination.titleText = mainPrizes[selectedRow?.row ?? 0].title
                destination.rewardText = mainPrizes[selectedRow?.row ?? 0].reward
                destination.typeText = "Main"
            } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
                //destination.sponsor = testBeginnerPrizes[selectedRow?.row ?? 0].sponsor
                destination.descriptionText = beginnerPrizes[selectedRow?.row ?? 0].description
                destination.titleText = beginnerPrizes[selectedRow?.row ?? 0].title
                destination.rewardText = beginnerPrizes[selectedRow?.row ?? 0].reward
                destination.typeText = "Beginner"
            } else {
                destination.descriptionText = startUpPrizes[selectedRow?.row ?? 0].description
                destination.titleText = startUpPrizes[selectedRow?.row ?? 0].title
                destination.rewardText = startUpPrizes[selectedRow?.row ?? 0].reward
                destination.typeText = "StartUp"
            }
        } else {
            destination.descriptionText = favoritePrizes[selectedRow?.row ?? 0].description
            destination.titleText = favoritePrizes[selectedRow?.row ?? 0].title
            destination.rewardText = favoritePrizes[selectedRow?.row ?? 0].reward
            destination.typeText = favoritePrizes[selectedRow?.row ?? 0].prizeType.rawValue
        }
        
    }
}
