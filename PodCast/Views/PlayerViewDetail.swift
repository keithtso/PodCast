//
//  PlayerViewDetail.swift
//  PodCast
//
//  Created by Keith Cao on 15/10/18.
//  Copyright © 2018 Keith Cao. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewDetail: UIView {
    
    
    var episode: Episode! {
        
        didSet{
            
            let url = URL(string: episode.imageURL?.toSecureHTTPS() ?? "")
//            change the miniplayer's properties
            miniEpisodeLabel.text = episode.title
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            episodeImageView.sd_setImage(with: url, completed: nil)
            
            
        }
        
    }
    
    //    MARK:- AVPlayer
    fileprivate func playEpisode() {
        
        guard let url = URL(string: episode.streamUrl.toSecureHTTPS()) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false
        return avplayer
    }()
    
    //monitor when the player will start playing
    fileprivate func observePlayerCurrentTime() {
        //        track the audio play back time
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            self?.currentTimeLabel.text = time.toDisplayString()
            
            if let duration = self?.player.currentItem?.duration {
                if CMTimeGetSeconds(duration).isNaN {
                    return
                }
                let difference = Int(CMTimeGetSeconds(duration)) - Int(CMTimeGetSeconds(time))
                let timeLeft = CMTime(value: CMTimeValue(difference), timescale: 1)
                self?.durationLabel.text = timeLeft.toDisplayString()
            }
            
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = Float(currentTime / duration)
        
        self.timeSlider.value = percentage
        
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observePlayerCurrentTime()
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
       panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        // observe when the audio will start playing by a boundary time observer
        let time = CMTime(value: 1, timescale: 3)
        
        let times = [NSValue(time: time)]
        //        player has a reference to self
        //        self has a reference to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
        }
    }
    
   
    
  
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        if gesture.state == .began {
            
        } else if gesture.state == .changed {
            
            handlePanChange(gesture)
            
        } else if gesture.state == .ended {
            
            handlePanEnded(gesture)
        }
        
    }
    
    fileprivate func handlePanChange(_ gesture: UIPanGestureRecognizer) {
        let translationPoint = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translationPoint.y)
        
        self.miniPlayerView.alpha = 1 + translationPoint.y / 200
        self.maximizedStackView.alpha = -translationPoint.y / 200
    }
    
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let translationPoint = gesture.translation(in: self.superview)
        
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            
            if translationPoint.y < -200 || velocity.y < -500 {
                let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                mainTabBarController?.maximizePlayerDetails(episode: nil)
                gesture.isEnabled = false
            } else{
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }
    
    
    @objc func handleTapMaximize() {
        
        
        let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabbarController?.maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    static func initFromNib() -> PlayerViewDetail {
        
        return Bundle.main.loadNibNamed("PlayerViewDetail", owner: self, options: nil)?.first as! PlayerViewDetail
    }
    
    deinit {
        print("playdetail memory being reclaimed")
    }
    
    //    MARK:- Outlet and Action
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniEpisodeLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        
        didSet{
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
        
    }
    @IBOutlet weak var miniFastforwardButton: UIButton!
    
    
    
    
    @IBAction func hanldeCurrentTimeSlider(_ sender: Any) {
        //calculate the percentage of time to play at
        let percentage = timeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        //        the player will seek to a specific time to play
        player.seek(to: seekTime)
        
    }
    
    
    @IBAction func handleRewind(_ sender: Any) {
        
        seekToCurrentTime(time: -15)
        
    }
    
    
    @IBAction func handleFastForward(_ sender: Any) {
        
        seekToCurrentTime(time: 15)
        
    }
    
    //    method to adjust the playing time
    fileprivate func seekToCurrentTime(time: Float64) {
        let fifteenSeconds = CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC))
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    //    adjust the volume by assign the slider's value to player's volume
    @IBAction func handleVolumeChange(_ sender: Any) {
        
        player.volume = volumeSlider.value
        
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
         let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabbarController?.minimizePlayerDetails()
        panGesture.isEnabled = true
    }
    
    fileprivate let shrinkTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.episodeImageView.transform = .identity     //bounce back to the original format
            
        }, completion: nil)
    }
    
    fileprivate func shrinkEpisodeImageView(){
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            
            self.episodeImageView.transform = self.shrinkTransform
            
        }, completion: nil)
    }
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        
        didSet{
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            
            
            episodeImageView.transform = self.shrinkTransform
            
        }
        
    }
    
    
    
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet{
            
            titleLabel.numberOfLines = 2
        }
    }
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    
    @IBOutlet weak var playPauseButton: UIButton! {
        
        didSet{
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
        
    }
    
    @objc func handlePlayPause() {
        print("pause or play media")
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
            
        }else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            
            shrinkEpisodeImageView()
        }
    }
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
}
