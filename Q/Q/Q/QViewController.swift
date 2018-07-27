//
//  QViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
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
    
    func appleMusicRequestPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                self.appleMusicAuthorized = true
                self.fetchStoreId()
                self.getUserToken()
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
    private let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlVZVVk0SEs2TlMifQ.eyJpc3MiOiJGS0JKTDM3SFBRIiwiaWF0IjoxNTMyNjY0NDQ3LCJleHAiOjE1MzI3MDc2NDd9.E8DSXmLmmkL9bl3EFcjweetKe4y7sR12nCVV5F8pmggXW4ZmexPzUv-6qvh4IxaGX7yElL6vp8QPXlVSg62_WA"
    var userToken: String?
    
    func getUserToken() {
        let serviceController = SKCloudServiceController()
        serviceController.requestUserToken(forDeveloperToken: self.developerToken) { (userToken: String?, error: Error?) in
            if error == nil, let token = userToken {
                self.userToken = token
            } else if error != nil {
                print(error!.localizedDescription)
            }
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
