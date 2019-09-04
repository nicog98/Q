//
//  Q.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation

class Q {
    
    var members: [QUser]
    
    var queue: [MediaItem]
    
    var identifiers: [String]
    
    var name: String
    
    init() {
        self.identifiers = []
        self.queue = []
        self.members = []
        self.name = ""
    }
    
    func addToQueue(mediaItem: MediaItem) {
        queue.append(mediaItem)
        identifiers.append(mediaItem.identifier)
    }
    
    func addMember(user: QUser) {
        members.append(user)
    }
    
}
