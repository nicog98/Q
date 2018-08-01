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
    
    var appleMusicController: AppleMusicController!
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        print("DEVELOPER TOKEN: \(self.appleMusicController.fetchDeveloperToken()!)")
        print("USER TOKEN: \(self.appleMusicAuthorizationController.userToken)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query music search with given keywords
        let keyword = searchBar.text
        let query = URL(string: "https://api.music.apple.com/v1/catalog/us/search/hints?term=\(keyword!)&limit=10&types=artists,albums")
        let session = URLSession.shared
        
        // query Apple Music API
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
