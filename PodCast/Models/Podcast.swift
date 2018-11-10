//
//  Podcast.swift
//  PodCast
//
//  Created by Keith Cao on 29/09/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
