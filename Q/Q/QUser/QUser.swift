//
//  QUser.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation
import Parse

protocol QUserDelegate {
    func setUser(user: QUser)
}

class QUser {
    
    var user: PFUser?
    
    public var qScore: Int? {
        didSet {
            user?["qScore"] = qScore
        }
    }
    
    var profilePictureData: Data? {
        didSet {
            let profilePicture = PFFile(name: "profile-picture.png", data: profilePictureData!)
            user?["profilePicture"] = profilePicture
        }
    }
    
    var username: String?
    
    var delegate: QUserDelegate?
    
    public func saveUserInfo() {
        user?.saveInBackground(block: { (success, error) in
            if success {
                print("SUCCESSFULLY SAVED USER INFO")
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    init(user: PFUser) {
        self.user = user
        self.username = user["username"] as? String
        self.qScore = user["qScore"] as? Int
        if let profilePicture = user["profilePicture"] as? PFFile {
            do {
                self.profilePictureData = try profilePicture.getData()
            } catch {
                print("UNABLE TO RETRIEVE PROFILE PICTURE DATA")
            }
        }
        
    }
    
}
