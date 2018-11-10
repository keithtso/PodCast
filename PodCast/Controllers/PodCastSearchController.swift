//
//  PodCastSearchController.swift
//  PodCast
//
//  Created by Keith Cao on 29/09/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import Alamofire

class PodCastSearchController: UITableViewController, UISearchBarDelegate{
    
    var podcasts = [Podcast]()
    
    let cellID = "cellID"
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
        setUpTableView()
        
        view.backgroundColor = .white
        
//        searchBar(searchController.searchBar, textDidChange: "Npr")
        
    }
    
    //MARK:- UITableView
    
    
    var podcastSearchView = Bundle.main.loadNibNamed("PodcastSearchView", owner: self, options: nil)?.first as? UIView
   override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //ternary operator
        return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeController = EpisodesController()
        let podcast = podcasts[indexPath.row]
        episodeController.podcast = podcast
        navigationController?.pushViewController(episodeController, animated: true)
    }
    
    
    fileprivate func setUpTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: cellID)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        
        let podcast = self.podcasts[indexPath.row]
        
        cell.podcast = podcast
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    //MARK:- SearchBar
    fileprivate func setUpSearchBar() {
        //add the searchBar to the navigation bar
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //set a time to delay the search function
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APIService.share.fetchPodcasts(searchText: searchText) { (podcasts) in
                
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
        
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
   
    
}
