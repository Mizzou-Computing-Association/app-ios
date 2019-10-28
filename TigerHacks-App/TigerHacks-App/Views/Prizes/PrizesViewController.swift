//
//  PrizesViewController.swift
//  TigerHacks-App
//
//  Created by Jonah Zukosky on 3/9/18.
//  Copyright © 2018 Zukosky, Jonah. All rights reserved.


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
        getFavoritedPrizes()
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
//                print("prizes from vc: \(prizes)")
                var tempPrizes = [Prize]()
                for prize in prizes {
                    let newPrize = Prize(sponsorID: prize.sponsorID, title: prize.title, reward: prize.reward, description: prize.description, prizeType: prize.prizeType, order: prize.order)
                    tempPrizes.append(newPrize)
                }
                self.allPrizes = tempPrizes
                self.sortPrizes()
                self.prizeTableView.reloadData()
//                print("tempPrizes from vc: \(tempPrizes)")
            }
        }
    }
    
    func sortPrizes() {
        allPrizes = allPrizes.sorted(by: { $0.order < $1.order })
        favoritePrizes = favoritePrizes.sorted(by: { $0.order < $1.order })
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
    
    func addFavorite(path: IndexPath) {
        getFavoritedPrizes()

        if favoritePrizes.filter({ $0.title == allPrizes[path.row].title }).count > 0 {
            print("prize is in favorite prizes")
        
            if let defaultFavorites = defaults.array(forKey: "Favorited"),
                let stringFavoritePrizes = defaultFavorites as? [String] {
                var newStringPrizes = stringFavoritePrizes
                newStringPrizes.removeAll { (title) -> Bool in
                    if title == allPrizes[path.row].title {
                        print("removing prize")
                        print(title)
                    }
                    return title == allPrizes[path.row].title
                }
                print(newStringPrizes)
                defaults.set(newStringPrizes, forKey: "Favorited")
            }
        } else {
            favoritePrizeTitles.append(allPrizes[path.row].title)
            if let defaultFavorites = defaults.array(forKey: "Favorited"),
                let stringFavoritePrizes = defaultFavorites as? [String] {
                print(Array(Set(stringFavoritePrizes + favoritePrizeTitles)))
                defaults.set(Array(Set(stringFavoritePrizes + favoritePrizeTitles)), forKey: "Favorited")
            } else {
                print(Array(Set(favoritePrizeTitles)))
                defaults.set(Array(Set(favoritePrizeTitles)), forKey: "Favorited")
            }
        }
        
        if let newFavorites = defaults.array(forKey: "Favorited") as? [String] {
            favoritePrizeTitles = newFavorites
        }
        
        prizeTableView.reloadData()
    }
    
    func toggleFavorited() {
        if favorited {
            favorited = false
            favoriteButton?.setBackgroundImage(favoriteIconImage, for: .normal)
            prizeTableView.reloadData()

        } else {
            favorited = true
            favoriteButton?.setBackgroundImage(favoriteSelectedIconImage, for: .normal)
            getFavoritedPrizes()
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
        print("Getting Favorited Prizes")
        if let favoritedArray = defaults.array(forKey: "Favorited"),
            let stringFavoritedArray = favoritedArray as? [String] {
            favoritePrizeTitles = stringFavoritedArray
            favoritePrizes = [Prize]()
            for title in favoritePrizeTitles {
                for prize in allPrizes {
                    if prize.title.last == "⭐️" {
                        var newTitle = prize.title
                        newTitle.removeLast()
                        newTitle.removeLast()
                        
                        if newTitle == title {
                           for (index, favoritePrize) in favoritePrizes.enumerated() where favoritePrize.title == title {
                               favoritePrizes.remove(at: index)
                           }
                           favoritePrizes.append(prize)
                       }
                    } else {
                        if prize.title == title {
                            for (index, favoritePrize) in favoritePrizes.enumerated() where favoritePrize.title == title {
                                favoritePrizes.remove(at: index)
                            }
                            favoritePrizes.append(prize)
                        }
                    }
                }
            }
            print("Favorite Prize Titles: \(favoritePrizeTitles)")
            print("Favorite Prizes: \(favoritePrizes)")
            sortPrizes()
            prizeTableView.reloadData()
        }
    }
    
// MARK: - Table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if favorited {
            return favoritePrizes.count
        } else {
            return allPrizes.count
//            if prizeTypeSwitcher.selectedSegmentIndex == 0 {
//                return mainPrizes.count
//            } else if prizeTypeSwitcher.selectedSegmentIndex == 1 {
//                return beginnerPrizes.count
//            } else {
//                return startUpPrizes.count
//            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prizeCell", for: indexPath) as! PrizeTableViewCell
    
        if !favorited {
            if favoritePrizeTitles.contains(allPrizes[indexPath.row].title) && allPrizes[indexPath.row].title.last != "⭐️" {
                print("Favorited: \(allPrizes[indexPath.row].title)")
                cell.prizeTitle.text = allPrizes[indexPath.row].title + " ⭐️"
                cell.prizeReward.text = "Reward: " + allPrizes[indexPath.row].reward
                cell.prizeType.text = "Type: " + allPrizes[indexPath.row].prizeType.rawValue
            } else {
                print("Not favorited: \(allPrizes[indexPath.row].title)")
                cell.prizeTitle.text = allPrizes[indexPath.row].title
                cell.prizeReward.text = "Reward: " + allPrizes[indexPath.row].reward
                cell.prizeType.text = "Type: " + allPrizes[indexPath.row].prizeType.rawValue
            }
            
        } else {
            if allPrizes[indexPath.row].title.last != "⭐️" {
                cell.prizeTitle.text = favoritePrizes[indexPath.row].title + " ⭐️"
                cell.prizeReward.text = "Reward: " + favoritePrizes[indexPath.row].reward
                cell.prizeType.text = "Type: " + favoritePrizes[indexPath.row].prizeType.rawValue
            } else {
                cell.prizeTitle.text = favoritePrizes[indexPath.row].title
                cell.prizeReward.text = "Reward: " + favoritePrizes[indexPath.row].reward
                cell.prizeType.text = "Type: " + favoritePrizes[indexPath.row].prizeType.rawValue
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !favorited {
            
            let favoriteAction = UIContextualAction(style: .normal, title:  "⭐️", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                self.addFavorite(path: indexPath)
                print("OK, marked as Closed")
                success(true)
            })
//            favoriteAction.image = UIImage(named: "favorite_selected")
            favoriteAction.backgroundColor = .systemYellow

            return UISwipeActionsConfiguration(actions: [favoriteAction])
        }
        
        return UISwipeActionsConfiguration(actions: [])
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
            destination.descriptionText = allPrizes[selectedRow?.row ?? 0].description
            destination.titleText = allPrizes[selectedRow?.row ?? 0].title
            destination.rewardText = allPrizes[selectedRow?.row ?? 0].reward
            destination.typeText = allPrizes[selectedRow?.row ?? 0].prizeType.rawValue
        } else {
            destination.descriptionText = favoritePrizes[selectedRow?.row ?? 0].description
            destination.titleText = favoritePrizes[selectedRow?.row ?? 0].title
            destination.rewardText = favoritePrizes[selectedRow?.row ?? 0].reward
            destination.typeText = favoritePrizes[selectedRow?.row ?? 0].prizeType.rawValue
        }
        
    }
}
