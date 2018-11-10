//
//  APIService.swift
//  PodCast
//
//  Created by Keith Cao on 30/09/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    //use singleton here
    static let share = APIService()
    
    let iTunesURL = "https://itunes.apple.com/search"
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()){
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl: feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        
        
        //feth the feed and parse it at the background
        DispatchQueue.global(qos: .background).async {
            
            let parser = FeedParser(URL: url)
            
            parser?.parseAsync(result: { (result) in
                print("succefully parse feed", result.isSuccess)
                
                if let err = result.error {
                    print("fail to parse XML Feed",err)
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
                
                
                
            })
        }
        
       
        
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        
        let parameters = ["term": searchText, "media": "podcast"]
        Alamofire.request(iTunesURL, method: .get
            , parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponds) in
                
                if let err = dataResponds.error {
                    print("fail to connect itune", err)
                    return
                }
                
                guard let data = dataResponds.data else { return }
                
                do {
                    
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    completionHandler(result.results)
//                    self.podcasts = result.results
//                    self.tableView.reloadData()
                }catch let err {
                    print("Fail to decode data: ", err)
                }
                
                
        }
    }
    
    
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
