//
//  AppleMusicConfiguration.swift
//  Q
//
//  Created by Nicolai Garcia on 12/23/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation

/// Struct to abstract Apple Music configuration (creating controller and handling authorization)
struct AppleMusicConfiguration {
    
    init() {
        // initialize Apple Music Controller
        self.appleMusicController = AppleMusicController()
        
        // initialize Apple Music Authorization controller
        self.appleMusicAuthorizationController = AppleMusicAuthorizationController(appleMusicController: self.appleMusicController)
    }
    
    // Handles Apple Music API
    var appleMusicController: AppleMusicController!
    
    // Handles Apple Music authorization
    var appleMusicAuthorizationController: AppleMusicAuthorizationController!
    
}
