//
//  EpisodesController.swift
//  PodCast
//
//  Created by Keith Cao on 2/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    fileprivate let cellID = "CellID"
    
    var podcast: Podcast? {
        
        didSet{
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    //use the FeedKit to parse the RSS XML
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        
        APIService.share.fetchEpisodes(feedUrl: feedUrl.toSecureHTTPS()) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK:- Register Cell
    fileprivate func setupTableView() {
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
    var episodes = [Episode]()
    
    //MARK:- UITableView
    
    
    //apply an indicator to atler the user that the episodes are loading
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityContainerView = UIActivityIndicatorView(style: .whiteLarge)
        activityContainerView.color = .darkGray
        activityContainerView.startAnimating()
        return activityContainerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 :0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        
        mainTabbarController?.maximizePlayerDetails(episode: episode)
        

//        let window = UIApplication.shared.keyWindow
//
//        let playerDetailView = PlayerViewDetail.initFromNib()
//        playerDetailView.episode = episode
//        playerDetailView.frame = self.view.frame
//        window?.addSubview(playerDetailView)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        
        let episode = episodes[indexPath.row]
        cell.episode = episode
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
}
