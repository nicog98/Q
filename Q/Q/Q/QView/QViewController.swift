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

class QViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
    MusicSearchTableViewControllerDelegate/*, MPMediaPlayback*/ {
    
    @IBOutlet weak var ArtworkImageView: UIImageView!
    
    @IBOutlet weak var QTitleTextField: UITextField!
    
    @IBOutlet weak var PreviousButton: UIButton!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var QueueTableView: UITableView!
    
    // music player used to play Apple Music songs, application queue player gives greater queue functionality
    let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    // all Apple Music songs in the queue
    var appleMusicMediaItemQueue: [MPMediaItem] = []
    
    @IBAction func addSong(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    // MARK: Changing Playback
    
    func playMusic() {
        switch musicPlayer.playbackState {
        case .stopped:
            musicPlayer.play()
        case .paused:
            musicPlayer.play()
        case .playing:
            musicPlayer.pause()
        default:
            return
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        // prepare music player to play if not prepared already
        if !musicPlayer.isPreparedToPlay {
            musicPlayer.setQueue(with: musicQueue.identifiers)
            musicPlayer.prepareToPlay { (error) in
                self.playMusic()
            }
        } else {
            playMusic()
        }
        
    }
    
    @IBAction func nextSong(_ sender: Any) {
        musicPlayer.skipToNextItem()
    }
    
    @IBAction func previousSong(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    
    // MARK: Changing Q Title
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // only change name if there is text
        if (textField.text != "") {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != musicQueue.name { // only save if the name changed
            musicQueue.name = textField.text!
        }
    }
    
    // Apple Music Controller handles Apple Music API searches
    var appleMusicController: AppleMusicController!
    
    // Apple Music Authorization Controller handles Apple Music and iClooud login
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    // instance of the Q model
    var musicQueue = Q()
    
    // MARK: View Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle Apple Music configuration, login etc.
        if let qNavigationController = self.navigationController as? QNavigationController {
            self.appleMusicController = qNavigationController.appleMusicController
            self.appleMusicAuthorizationController = qNavigationController.appleMusicAuthorizationController
        }
        
        self.QueueTableView.delegate = self
        self.QueueTableView.dataSource = self
        self.QTitleTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        
        // music player playback notifications to be handled
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
        
        // app lifecycle notifications
        notificationCenter.addObserver(self, selector: #selector(willTerminate),
                                       name: .UIApplicationWillTerminate,
                                       object: nil)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Adding songs to the Q
    
    @IBAction func addToQ(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    func addSongToQueue(songIdentifier: String) {
        let appleMusicStoreQueueDescriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [songIdentifier])
        musicPlayer.append(appleMusicStoreQueueDescriptor)
    }
    
    //
    func didSelectSong(mediaItem: MediaItem) {
        musicQueue.addToQueue(song: mediaItem)
        self.QueueTableView.reloadData()
        addSongToQueue(songIdentifier: mediaItem.identifier)
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
    
    // MARK: Changing Song
    
    func selectSongInQueue(songIndexPath: IndexPath) {
        // only change song if it is different
        if songIndexPath.row != musicPlayer.indexOfNowPlayingItem {
            // skip to next or previous if selected is one away
            if songIndexPath.row == musicPlayer.indexOfNowPlayingItem-1 {
                musicPlayer.skipToPreviousItem()
            } else if songIndexPath.row == musicPlayer.indexOfNowPlayingItem+1 {
                musicPlayer.skipToNextItem()
            } else {
                musicPlayer.pause()
                // create a new descriptor, setting the start song to the specified song in the queue
                let newQueueStoreDescriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: musicQueue.identifiers)
                newQueueStoreDescriptor.startItemID = musicQueue.identifiers[songIndexPath.row]
                musicPlayer.setQueue(with: newQueueStoreDescriptor)
                musicPlayer.play()
            }
        }
        QueueTableView.deselectRow(at: songIndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Play queue from song selected at indexPath
        selectSongInQueue(songIndexPath: indexPath)
    }
    
    // MARK: Music Player Playback Notification Handlers
    
    @objc func nowPlayingItemDidChange() {
        let mediaItemIndex = musicPlayer.indexOfNowPlayingItem
        let mediaItem = musicQueue.queue[mediaItemIndex]
        let artworkUrl = mediaItem.artwork.imageURL(size: CGSize(width: mediaItem.artwork.width, height: mediaItem.artwork.height))
        ArtworkImageView.sd_setImage(with: artworkUrl, placeholderImage: UIImage())
    }
    
    // change UI based on playback state
    @objc func playbackStateDidChange() {
        switch musicPlayer.playbackState {
        case .interrupted:
            musicPlayer.pause()
        case .paused:
            PlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        case .playing:
            PlayButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        case .stopped:
            PlayButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
        default:
            return
        }
    }
    
    // TODO: Implement for volume to change
    @objc func volumeDidChange() {
        
    }
    
    // MARK: MPMediaPlayback Protocol Methods
    // TODO: Implement for more control over music
//    func prepareToPlay() {
//        <#code#>
//    }
//
//    var isPreparedToPlay: Bool
//
//    func play() {
//        <#code#>
//    }
//
//    func pause() {
//        <#code#>
//    }
//
//    func stop() {
//        <#code#>
//    }
//
//    var currentPlaybackTime: TimeInterval
//
//    var currentPlaybackRate: Float
//
//    func beginSeekingForward() {
//        <#code#>
//    }
//
//    func beginSeekingBackward() {
//        <#code#>
//    }
//
//    func endSeeking() {
//        <#code#>
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMusicSearch" {
            if let musicSearchViewController = segue.destination as? MusicSearchTableViewController {
                musicSearchViewController.delegate = self
            }
        }
    }
    
    @objc func willTerminate() {
        musicPlayer.pause()
    }

}
