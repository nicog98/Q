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
    QNavigationViewControllerDelegate/*, MPMediaPlayback*/ {
    
    // MARK: UI
    
    @IBOutlet weak var ArtworkImageView: UIImageView!
    
    @IBOutlet weak var QTitleTextField: UITextField!
    
    @IBOutlet weak var PreviousButton: UIButton!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var NextButton: UIButton!
    
    @IBOutlet weak var AddButton: UIBarButtonItem!
    
    @IBOutlet weak var QueueTableView: UITableView!
    
    // Music player used to play Apple Music songs, application queue player gives greater queue functionality
    let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    @IBAction func addSong(_ sender: Any) {
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
            musicPlayer.setQueue(with: q.identifiers)
            musicPlayer.prepareToPlay { (error) in
                guard error == nil else {
                    return
                }
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
    
    // MARK: Music Player Playback Notification Handlers
    
    @objc func nowPlayingItemDidChange() {
        let mediaItemIndex = musicPlayer.indexOfNowPlayingItem
        let mediaItem = q.queue[mediaItemIndex]
        let artworkUrl = mediaItem.artwork.imageURL(height: Int(ArtworkImageView.frame.height), width: Int(ArtworkImageView.frame.width))
        ArtworkImageView.sd_setImage(with: artworkUrl, placeholderImage: UIImage())
    }
    
    // change UI based on playback state
    @objc func playbackStateDidChange() {
        switch musicPlayer.playbackState {
        case .interrupted:
            musicPlayer.pause()
        case .paused:
            PlayButton.isHidden = false
        case .playing:
            PlayButton.isHidden = true
        case .stopped:
            PlayButton.isHidden = true
        default:
            return
        }
    }
    
    // MARK: Changing Q Title
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text != "") { // only change name if there is text
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != q.name { // only save if the name changed
            q.name = textField.text!
        }
    }
    
    // Handles apple music configuration (API queries, authorization)
    var appleMusicConfiguration: AppleMusicConfiguration?
    
    // instance of the Q model
    var q = Q()
    
    // parent UINavigationController
    var qNavigationController: QNavigationViewController?
    
    // MARK: View Loading Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appleMusicConfiguration = (self.navigationController as? QNavigationViewController)?.appleMusicConfiguration
        self.qNavigationController = self.navigationController as? QNavigationViewController
        self.qNavigationController?.qNavigationViewControllerDelegate = self
        
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
    
    func addToQueue(mediaItem: MediaItem) {
        if mediaItem.type == .song {
            q.addToQueue(mediaItem: mediaItem)
            let mediaItemIdentifier = mediaItem.identifier
            let appleMusicStoreQueueDescriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [mediaItemIdentifier])
            musicPlayer.append(appleMusicStoreQueueDescriptor)
        } else if mediaItem.type == .album {
            for song in mediaItem.tracks! {
                addToQueue(mediaItem: song)
            }
        }
    }
    
    // MARK: QNavigationViewControllerDelegate methods
    func didSelectMediaItem(mediaItem: MediaItem) {
        addToQueue(mediaItem: mediaItem)
        self.QueueTableView.reloadData()
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.q.queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let songCell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as? QTableViewCell {
            songCell.mediaItem = self.q.queue[indexPath.row]
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
                let newQueueStoreDescriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: q.identifiers)
                newQueueStoreDescriptor.startItemID = q.identifiers[songIndexPath.row]
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
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set up MusicSearch
    }
    
    // MARK: Handle killing the app
    @objc func willTerminate() {
        musicPlayer.pause()
    }

}
