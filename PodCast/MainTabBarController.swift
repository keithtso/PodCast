//
//  MainTabBarController.swift
//  PodCast
//
//  Created by Keith Cao on 29/09/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple
       
        setupViewControllers()
        
        setupPlayerDetailView()
        
        
    }
    
    //MARK:- Helper Functions
    
    @objc func minimizePlayerDetails() {
        
        maxTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailView.maximizedStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
            
        }, completion: nil)
        
    }
    
    func maximizePlayerDetails(episode: Episode?) {
        minTopAnchorConstraint.isActive = false
        maxTopAnchorConstraint.isActive = true
        maxTopAnchorConstraint.constant = 0
       
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            playerDetailView.episode = episode
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailView.maximizedStackView.alpha = 1
            self.playerDetailView.miniPlayerView.alpha = 0
            
        }, completion: nil)
        
    }
    
    var maxTopAnchorConstraint: NSLayoutConstraint!
    var minTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    let playerDetailView = PlayerViewDetail.initFromNib()
    
    fileprivate func setupPlayerDetailView() {
        
        
        
//        view.addSubview(playerDetailView)
        
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        playerDetailView.durationLabel.text = "--:--"
        maxTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        maxTopAnchorConstraint.isActive = true
        
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        
        
        
        minTopAnchorConstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minTopAnchorConstraint.isActive = true
        
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        
        
    }
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
        
    }
    
    fileprivate func setupViewControllers() {
        let favoritesController = generateNavigationController(with: ViewController(), title: "Favorites", image: UIImage(named: "favorites")!)
        
        let searchNavController = generateNavigationController(with: PodCastSearchController(), title: "Search", image: UIImage(named: "search")!)
        
        let downloadController = generateNavigationController(with: ViewController(), title: "Downloads", image: UIImage(named: "downloads")! )
        
        viewControllers = [searchNavController,favoritesController, downloadController]
    }
    
    
}
