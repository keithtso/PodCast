//
//  CMTime.swift
//  PodCast
//
//  Created by Keith Cao on 16/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        
        let hours = totalSeconds / 120
        
        if hours > 0 {
            let timeFormatString = String(format: "%02d:%02d:%02d", hours ,minutes,seconds)
            return timeFormatString
        } else {
            let timeFormatString = String(format: "%02d:%02d", minutes,seconds)
            return timeFormatString
        }
        
        
        
    }
    
    
}
