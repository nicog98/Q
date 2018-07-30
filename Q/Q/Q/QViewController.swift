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

class QViewController: UIViewController {
    
    @IBOutlet weak var ArtworkImageView: UIImageView!
    
    @IBOutlet weak var QTitleLabel: UILabel!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var AddButton: UIButton!
    
    @IBOutlet weak var QCollectionView: UICollectionView!
    
    @IBAction func addSong(_ sender: UIButton) {
        if (appleMusicAuthorized) {
            performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleMusicRequestPermission()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToQ(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    
    // APPLE MUSIC INTEGRATION
    
    // Check device Apple Music capabilities
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability:SKCloudServiceCapability, error) in
            if capability.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
                // Apple Music subscription, music playback, add to iCloud music library
            } else if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                // Apple Music subscription, music playback
            } else if capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) {
                // No Apple music subscription available
            }
        }
    }
    
    // Request permission for Apple Music library
    var appleMusicAuthorized: Bool = false
    var mediaLibraryAuthorized: Bool = false
    
    func mediaLibraryRequestPermission() {
        MPMediaLibrary.requestAuthorization { (status:MPMediaLibraryAuthorizationStatus) in
            switch status {
            case .authorized:
                self.mediaLibraryAuthorized = true
            case .denied:
                self.mediaLibraryAuthorized = false
            case .notDetermined:
                self.mediaLibraryAuthorized = false
            case .restricted:
                self.mediaLibraryAuthorized = false
            }
        }
    }
    
    func appleMusicRequestPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                self.appleMusicAuthorized = true
                self.fetchStoreId()
                self.fetchDeveloperToken()
            case .denied:
                self.appleMusicAuthorized = false
            case .restricted:
                self.appleMusicAuthorized = false
            case .notDetermined:
                self.appleMusicAuthorized = false
            }
        }
    }
    
    // Play Music
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    func appleMusicPlayTrack(ids:[String]) {
        musicPlayer.setQueue(with: ids)
        musicPlayer.play()
    }
    
    // Fetch user's storefront ID
    
    var storeFrontId: String?
    var developerToken: String?
    var userToken: String?

    func fetchStoreId() {
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier { (storeFrontId:String?, error:Error?) in
            if error == nil, let id = storeFrontId {
                self.storeFrontId = id
            } else {
                print ("ERROR FETCHING STORE ID: \(error!.localizedDescription)")
            }
        }
    }
    
    func fetchDeveloperToken() {
        let query = PFQuery(className: "DeveloperToken")
        query.whereKeyExists("developerToken")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let objects = objects {
                    let tokenObject = objects[0]
                    if let token = tokenObject["developerToken"] as? String {
                        self.developerToken = token
                        self.fetchUserToken()
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func fetchUserToken() {
        let serviceController = SKCloudServiceController()
        serviceController.requestUserToken(forDeveloperToken: self.developerToken!) { (userToken: String?, error: Error?) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let userToken = userToken else {
                print("UNEXPECTED VALUE FOR USER TOKEN")
                return
            }
            
            self.userToken = userToken
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMusicSearch" {
            if appleMusicAuthorized, let musicSearch = segue.destination as? MusicSearchViewController {
                musicSearch.appleMusicDeveloperToken = self.developerToken
                musicSearch.appleMusicUserToken = self.userToken
                musicSearch.appleMusicAuthorized = self.appleMusicAuthorized
                musicSearch.appleMusicStoreFrontId = self.storeFrontId
            }
        }
    }

}
