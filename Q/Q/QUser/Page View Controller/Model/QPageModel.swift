//
//  QPageModel.swift
//  Q
//
//  Created by Nicolai Garcia on 1/4/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import Foundation

class QPageModel {
    
    /// Int to hold the current index of the page
    var currentViewControllerIndex: Int!
    
    /// An instance of the Apple Music configuration
    var appleMusicConfiguration: AppleMusicConfiguration?
    
    /// Array of identifiers each corresponding to the ViewController in the PageViewController
    var viewControllerIdentifiers: [String]!
    
    init(appleMusicConfiguration: AppleMusicConfiguration?) {
        self.appleMusicConfiguration = appleMusicConfiguration
    }
    
}
