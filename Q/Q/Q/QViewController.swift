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

class QViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MusicSearchTableViewControllerDelegate {
    
    @IBOutlet weak var ArtworkImageView: UIImageView!
    
    @IBOutlet weak var QTitleLabel: UILabel!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var QueueTableView: UITableView!
    
    let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
    
    @IBAction func addSong(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    var isPlaying: Bool = false
    
    @IBAction func play(_ sender: UIButton) {
        musicPlayer.setQueue(with: musicQueue.identifiers)
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        isPlaying = true
    }
    
    var appleMusicController: AppleMusicController!
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    var musicQueue = Q()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appleMusicController = AppleMusicController()
        self.appleMusicAuthorizationController = AppleMusicAuthorizationController(appleMusicController: self.appleMusicController)
        
        self.QueueTableView.delegate = self
        self.QueueTableView.dataSource = self
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
