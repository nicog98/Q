//
//  QUserViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse

class QUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var UsernameLabel: UILabel!
    
    @IBOutlet weak var PlaylistCollectionView: UICollectionView!
    
    @IBOutlet weak var ContainerView: UIView!
    
    var qPageViewController: MiniQPageViewController!
    
    var qPageModel: QPageModel!
    
    var user: QUser?
    
    /// MARK: Profile Picture
    
    @IBOutlet weak var ProfilePictureImageView: UIImageView! {
        didSet {
            ProfilePictureImageView.layer.cornerRadius = ProfilePictureImageView.frame.height/2
            ProfilePictureImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var EditButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func editProfilePicutre(_ sender: UIButton) {
        // open photos
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                imagePicker.mediaTypes = mediaTypes
                self.present(imagePicker, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImageURL = info[UIImagePickerControllerImageURL] as? URL {
            do {
                let imageData = try Data(contentsOf: chosenImageURL)
                self.user?.profilePictureData = imageData
                self.ProfilePictureImageView.image = UIImage(data: imageData)
                dismiss(animated: true) {
                    // save photo to cloud
                    self.user?.saveUserInfo()
                }
            } catch {
                print("Unable to load image.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /// MARK: UICollectionView protocol methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.user?.playlists.count)! + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < self.user!.playlists.count {
            return UICollectionViewCell()
        } else if indexPath.item == self.user!.playlists.count {
            // return AddCell
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as? AddCollectionViewCell
            return addCell ?? UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    /// MARK: CollectionViewCell Selection
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < self.user!.playlists.count {
            // Selected existing playlist
        } else if indexPath.item == self.user!.playlists.count {
            // Selected add new playlist
        }
    }
    
    // MARK: Configuring Apple Music
    
    var appleMusicConfiguration: AppleMusicConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UsernameLabel.text = self.user?.username!
        if let profilePictureData = self.user?.profilePictureData {
            self.ProfilePictureImageView.image = UIImage(data: profilePictureData)
        } else {
            self.ProfilePictureImageView.image = UIImage(named: "Virgil")
        }
        
        // Handle Apple Music configuration, login, etc.
        self.appleMusicConfiguration = AppleMusicConfiguration()
        
        // set up delegates
        imagePicker.delegate = self
        PlaylistCollectionView.delegate = self
        PlaylistCollectionView.dataSource = self
        
        // set up page controller model
        self.qPageModel = QPageModel(appleMusicConfiguration: self.appleMusicConfiguration)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Handling notifications

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedQPageViewController", let qPageViewController = segue.destination as? MiniQPageViewController {
            self.qPageViewController = qPageViewController
        } else if segue.identifier == "ShowQ", let qViewController = segue.destination as? QViewController {
            qViewController.appleMusicConfiguration = self.appleMusicConfiguration
        }
    }

}
