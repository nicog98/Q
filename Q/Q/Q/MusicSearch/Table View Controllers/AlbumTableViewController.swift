//
//  AlbumTableViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 11/19/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    // Instance of overarching navigation controller
    var musicSearchNavigationViewController: MusicSearchNavigationViewController?
    
    // Handles Apple Music configuration (Apple Music API queries, authorization)
    var appleMusicConfiguration: AppleMusicConfiguration?
    
    var album: MediaItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Get instance of navigation controller
        self.musicSearchNavigationViewController = self.navigationController as? MusicSearchNavigationViewController
        
        // Configure music library controllers
        self.appleMusicConfiguration = musicSearchNavigationViewController?.appleMusicConfiguration
        
        requestAlbum()
    }
    
    // MARK: Request Album
    func requestAlbum() {
        appleMusicConfiguration?.appleMusicController.performAppleMusicCatalogRequest(
            countryCode: (appleMusicConfiguration?.appleMusicAuthorizationController.cloudServiceStorefrontCountryCode)!,
            requestIdentifier: album.identifier,
            relationship: AppleMusicController.appleMusicCatalogRequestRelationships.tracks) { (tracks: [MediaItem], error: Error?) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.album.tracks = tracks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (album?.tracks?.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let albumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as? AlbumTableViewCell {
                albumCell.mediaItem = self.album
                return albumCell
            }
        } else {
            if let songCell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as? SongTableViewCell {
                songCell.mediaItem = self.album?.tracks?[indexPath.row-1] ?? nil
                return songCell
            }
        }
        return UITableViewCell()
    }

    // MARK: Table View Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMediaItem: MediaItem
        if indexPath.row == 0 { // select entire album if clicked on header
            selectedMediaItem = album
        } else { // select a song from the album
            selectedMediaItem = album!.tracks![indexPath.row-1]
        }
        musicSearchNavigationViewController?.musicSearchDelegate?.didSelectMediaItem(mediaItem: selectedMediaItem)
        dismiss(animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
