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
    
    var profilePicture: UIImage?
    
    var username: String?
    
    var delegate: QUserDelegate?
    
    init(user: PFUser) {
        self.user = user
        self.username = user["username"] as? String
    }
    
}
