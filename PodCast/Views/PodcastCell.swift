//
//  PodcastCell.swift
//  PodCast
//
//  Created by Keith Cao on 30/09/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        
        didSet{
             trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            
            //loading data from an url of an api
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            
//            URLSession.shared.dataTask(with: url) { (data, _, _) in
//                print("finish downloading image data", data)
//
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    self.podcastImageView.image = UIImage(data: data)
//                }
//
//
//            }.resume()
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
}
