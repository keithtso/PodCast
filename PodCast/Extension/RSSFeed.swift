//
//  RSSFeed.swift
//  PodCast
//
//  Created by Keith Cao on 7/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodesTemp = [Episode]()
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            if episode.imageURL == nil {
                episode.imageURL = imageUrl
            }
            
            episodesTemp.append(episode)
        })
        return episodesTemp
    }
    
}
