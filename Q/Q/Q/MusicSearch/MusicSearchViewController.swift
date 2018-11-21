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

class MusicSearchTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    struct appleMusicCatalogRequestRelationships {
        static let tracks = "tracks"
        
        static let artists = "artists"
        
        static let genres = "genres"
    }
    
    private static let numSections = 2
    
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
        
        // Set up search bar/view controller
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // configure table view Autolayout
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = MusicSearchTableViewController.TableViewConstants.estimatedRowHeight
        tableView.keyboardDismissMode = .onDrag // hide keyboard when user scrolls table view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.isActive = true
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
        return MusicSearchTableViewController.numSections
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard mediaItems.count > indexPath.section, mediaItems[indexPath.section].count > 0 else { // only load values if there arre media items to fit
            return UITableViewCell()
        }
        
        let mediaItem = mediaItems[indexPath.section][indexPath.row]
        var cell: MusicSearchTableViewCell?
        
        switch mediaItem.type {
        case .songs:
            cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongTableViewCell
        case .albums:
            cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumTableViewCell
        default:
            break
        }
        
        cell?.mediaItem = mediaItem
        
        return cell ?? UITableViewCell()
        
    }
    
    var selectedAlbum: AlbumTableViewCell?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMediaItem = mediaItems[indexPath.section][indexPath.row]
        if selectedMediaItem.type == .songs {
            delegate?.didSelectSong(mediaItem: selectedMediaItem)
            searchController.isActive = false
            dismiss(animated: true)
        } else if selectedMediaItem.type == .albums { // album
            if let albumCell = tableView.cellForRow(at: indexPath) as? AlbumTableViewCell {
                self.selectedAlbum = albumCell
                performSegue(withIdentifier: "ShowAlbum", sender: self)
            }
        }
    }
    
    // MARK: Search Bar Delegate Methods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
    
    // MARK: Search Controller Delegate Methods
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbum" {
            
            // pass selected album to new view controller
            if let albumTableViewController = segue.destination as? AlbumTableViewController {
                albumTableViewController.appleMusicController = self.appleMusicController
                albumTableViewController.appleMusicAuthorizationController = self.appleMusicAuthorizationController
                albumTableViewController.album = selectedAlbum?.mediaItem
            }
        }
    }
    
    // MARK: Miscellaneous
    
    
    
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

extension MusicSearchTableViewController {
    
    struct TableViewConstants {
        static let estimatedRowHeight: CGFloat = 80.0
    }
    
}

