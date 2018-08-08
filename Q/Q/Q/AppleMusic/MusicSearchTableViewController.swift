//
//  MusicSearchViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/26/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class MusicSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // Handle Apple Music API queries
    var appleMusicController = AppleMusicController()
    
    // Handle Apple Music authorization
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    // Allow for music searching and updating search results
    var searchController = UISearchController(searchResultsController: nil)
    
    // A `DispatchQueue` used for synchronizing the setting of `mediaItems` to avoid threading issues with various `UITableView` delegate callbacks.
    var setterQueue = DispatchQueue(label: "MediaSearchTableViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        print("DEVELOPER TOKEN: \(self.appleMusicController.fetchDeveloperToken()!)")
        print("USER TOKEN: \(self.appleMusicAuthorizationController.userToken)")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MusicSearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for SearchController: UISearchController) {
        
    }
    
}
