//
//  QUserViewController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import UIKit
import Parse

class QUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBOutlet weak var UsernameLabel: UILabel!
    
    @IBOutlet weak var startQButton: UIButton!
    
    var user: QUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UsernameLabel.text = self.user?.username!
        if let profilePictureData = self.user?.profilePictureData {
            self.ProfilePictureImageView.image = UIImage(data: profilePictureData)
        }
        
        // set up delegates
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func startQ(_ sender: Any) {
        performSegue(withIdentifier: "ShowQ", sender: sender)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowQ", let qView = segue.destination as? QViewController {
            // initialize Q view controller
        }
    }

}
