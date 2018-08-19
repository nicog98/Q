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
    
    var queue: [MediaItem] {
        didSet {
            for mediaItem in queue {
                identifiers.append(mediaItem.identifier)
            }
        }
    }
    
    var identifiers: [String]
    
    init() {
        self.identifiers = []
        self.queue = []
        self.members = []
    }
    
    init(musicQueue: [MediaItem]) {
        self.identifiers = []
        self.queue = musicQueue
        self.members = []
    }
    
    mutating func addToQueue(song: MediaItem) {
        queue.append(song)
        identifiers.append(song.identifier)
    }
    
    mutating func addMember(user: QUser) {
        members.append(user)
    }
    
}
