//
//  QViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse
import StoreKit
import MediaPlayer
import SDWebImage

class QViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MusicSearchTableViewControllerDelegate {
    
    @IBOutlet weak var ArtworkImageView: UIImageView!
    
    @IBOutlet weak var QTitleLabel: UILabel!
    
    @IBOutlet weak var PreviousButton: UIButton!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var QueueTableView: UITableView!
    
    let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    @IBAction func addSong(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    @IBAction func previousSong(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        if !musicPlayer.isPreparedToPlay {
            musicPlayer.setQueue(with: musicQueue.identifiers)
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        } else {
            switch musicPlayer.playbackState {
            case .stopped:
                musicPlayer.setQueue(with: musicQueue.identifiers)
                musicPlayer.prepareToPlay()
                musicPlayer.play()
            case .paused:
                musicPlayer.play()
            case .playing:
                musicPlayer.pause()
            default:
                return
            }
        }
        
    }
    
    @IBAction func nextSong(_ sender: Any) {
        musicPlayer.skipToNextItem()
    }
    
    
    var appleMusicController: AppleMusicController!
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    var musicQueue = Q()
    
    // MARK: View Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appleMusicController = AppleMusicController()
        self.appleMusicAuthorizationController = AppleMusicAuthorizationController(appleMusicController: self.appleMusicController)
        
        self.QueueTableView.delegate = self
        self.QueueTableView.dataSource = self
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(nowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(playbackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(volumeDidChange),
                                       name: .MPMusicPlayerControllerVolumeDidChange,
                                       object: nil)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToQ(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    // MARK: MusicSearchViewController delegate methods
    
    func didSelectSong(mediaItem: MediaItem) {
        musicQueue.addToQueue(song: mediaItem)
        self.QueueTableView.reloadData()
        let storeQueueDescriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [mediaItem.identifier])
        musicPlayer.append(storeQueueDescriptor)
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicQueue.queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let songCell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as? QTableViewCell {
            songCell.mediaItem = self.musicQueue.queue[indexPath.row]
            return songCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Play queue from song selected at indexPath
        // Set now playing item to correct song in queue
        musicPlayer.perform(queueTransaction: { (queue: MPMusicPlayerControllerMutableQueue) in
            self.musicPlayer.pause()
        }) { (queue: MPMusicPlayerControllerQueue, error: Error?) in
            guard error == nil else {
                print("ERROR MUTATING QUEUE: \(error!)")
                return
            }
            self.musicPlayer.nowPlayingItem = queue.items[indexPath.row]
            self.musicPlayer.play()
            self.QueueTableView.deselectRow(at: indexPath, animated: true   )
        }
        
    }
    
    // MARK: Music Player Notification Handlers
    
    @objc func nowPlayingItemDidChange() {
        let mediaItemIndex = musicPlayer.indexOfNowPlayingItem
        let mediaItem = musicQueue.queue[mediaItemIndex]
        let artworkUrl = mediaItem.artwork.imageURL(size: CGSize(width: mediaItem.artwork.width, height: mediaItem.artwork.height))
        ArtworkImageView.sd_setImage(with: artworkUrl, placeholderImage: UIImage())
    }
    
    @objc func playbackStateDidChange() {
        switch musicPlayer.playbackState {
        case .interrupted:
            musicPlayer.pause()
        case .paused:
            PlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        case .playing:
            PlayButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        case .stopped:
            musicPlayer.setQueue(with: musicQueue.identifiers)
            PlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        default:
            return
        }
    }
    
    @objc func volumeDidChange() {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMusicSearch" {
            if let musicSearchViewController = segue.destination as? MusicSearchTableViewController {
                // passing appleMusic api to search
                musicSearchViewController.appleMusicController = self.appleMusicController
                musicSearchViewController.appleMusicAuthorizationController = self.appleMusicAuthorizationController
                musicSearchViewController.delegate = self
            }
        }
    }

}
