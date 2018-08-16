//
//  MusicSearchViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/26/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

protocol MusicSearchTableViewControllerDelegate {
    func didSelectSong(mediaItem: MediaItem)
}

class MusicSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var delegate: MusicSearchTableViewControllerDelegate?
    
    // Handle Apple Music API queries
    var appleMusicController = AppleMusicController()
    
    // Handle Apple Music authorization
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    // Allow for music searching and updating search results
    let searchController = UISearchController(searchResultsController: nil)
    
    // A `DispatchQueue` used for synchronizing the setting of `mediaItems` to avoid threading issues with various `UITableView` delegate callbacks.
    var setterQueue = DispatchQueue(label: "MediaSearchTableViewController")
    
    // Holds results of music search
    var mediaItems = [[MediaItem]]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appleMusicController.fetchDeveloperToken() == nil {
            
            searchController.searchBar.isUserInteractionEnabled = false
            
            let alertController = UIAlertController(title: "Error",
                                                    message: "No developer token was specified. See the README for more information.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            searchController.searchBar.isUserInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mediaItems.count > section ? self.mediaItems[section].count : 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "SONGS"
        } else if section == 1 {
            return "ALBUMS"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 120
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // Song
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell {
                let mediaItem = mediaItems[indexPath.section][indexPath.row]
                if mediaItem.type == .songs {
                    cell.mediaItem = mediaItem
                    return cell
                }
            }
        } else if indexPath.section == 1 { // Album
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumTableViewCell {
                let mediaItem = mediaItems[indexPath.section][indexPath.row]
                if mediaItem.type == .albums {
                    cell.mediaItem = mediaItem
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    var selectedIndexPath: IndexPath?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let selectedMediaItem = mediaItems[indexPath.section][indexPath.row]
        if selectedMediaItem.type == .songs {
            delegate?.didSelectSong(mediaItem: selectedMediaItem)
            dismiss(animated: false)
            dismiss(animated: true) {
                self.selectedIndexPath = nil
            }
        } else { // album
            // segue to show songs in album
        }
    }
    
    //    MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
}

extension MusicSearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for SearchController: UISearchController) {
        guard let searchString = self.searchController.searchBar.text else {
            return
        }
        
        if searchString == "" {
            self.setterQueue.sync {
                self.mediaItems = []
            }
        } else {
            appleMusicController.performAppleMusicCatalogSearch(with: searchString, countryCode: appleMusicAuthorizationController.cloudServiceStorefrontCountryCode) { (results: [[MediaItem]], error: Error?) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.mediaItems = results
            }
        }
    }
    
}