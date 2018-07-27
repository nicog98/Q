//
//  MusicSearchViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/26/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit

class MusicSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    var appleMusicAuthorized: Bool = false
    var appleMusicDeveloperToken: String?
    var appleMusicUserToken: String?
    var appleMusicStoreFrontId: String?
    // var spotifyAuthorized: Bool = false
    // var soundCloudAuthorized: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print("DEVELOPER TOKEN: \(self.appleMusicDeveloperToken)")
        print("USER TOKEN: \(self.appleMusicUserToken)")
        print("STORE FRONT ID: \(self.appleMusicStoreFrontId)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query music search with given keywords
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
