//
//  Q.swift
//  Q
//
//  Created by Nicolai Garcia on 7/22/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation

struct Q {
    
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
    
    mutating func addToQueue(mediaItem: MediaItem) {
        queue.append(mediaItem)
        identifiers.append(mediaItem.identifier)
    }
    
    mutating func addMember(user: QUser) {
        members.append(user)
    }
    
}
