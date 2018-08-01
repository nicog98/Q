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
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    @IBAction func play(_ sender: UIButton) {
    }
    
    var appleMusicController: AppleMusicController!
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMusicControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToQ(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowMusicSearch", sender: sender)
    }
    
    func initializeMusicControllers() {
        let query = PFQuery(className: "DeveloperToken")
        query.whereKeyExists("developerToken")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let objects = objects else {
                print("Unexpected value when fetching developer token.")
                return
            }
            
            let tokenObject = objects[0]
            if let developerToken = tokenObject["developerToken"] as? String {
                self.appleMusicController = AppleMusicController(developerToken: developerToken)
                self.appleMusicAuthorizationController = AppleMusicAuthorizationController(appleMusicController: self.appleMusicController)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMusicSearch" {
            if let musicSearchViewController = segue.destination as? MusicSearchViewController {
                // passing appleMusic api to search
                musicSearchViewController.appleMusicController = self.appleMusicController
                musicSearchViewController.appleMusicAuthorizationController = self.appleMusicAuthorizationController
            }
        }
    }

}
