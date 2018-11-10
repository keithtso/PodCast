//
//  Episode.swift
//  PodCast
//
//  Created by Keith Cao on 7/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation
import FeedKit

struct  Episode {
    let title: String
    let pubDate: Date
    let description: String
    var imageURL: String?
    let author: String
    let streamUrl: String
    
    
    init(feedItem: RSSFeedItem) {
        
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        
        //set the episode's image with a href
        self.imageURL = feedItem.iTunes?.iTunesImage?.attributes?.href
        
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        
    }
}
