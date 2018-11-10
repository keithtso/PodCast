//
//  EpisodeCell.swift
//  PodCast
//
//  Created by Keith Cao on 7/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        
        didSet {
            titleLable.text  = episode.title
            descriptionLable.text = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            pubDateTitle.text = dateFormatter.string(from: episode.pubDate)
            
            let url = URL(string: episode.imageURL?.toSecureHTTPS() ?? "")
            
            episodeImageView.sd_setImage(with: url, completed: nil)
            
            
        }
        
    }
    
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    
    @IBOutlet weak var pubDateTitle: UILabel!
    
    @IBOutlet weak var titleLable: UILabel! {
        
        didSet{
            titleLable.numberOfLines = 2
        }
        
    }
    
    
    @IBOutlet weak var descriptionLable: UILabel! {
        didSet{
            descriptionLable.numberOfLines = 2
        }
    }
    
}
