//
//  Playlist.swift
//  Q
//
//  Model for Q Playlist
//
//  Created by Nicolai Garcia on 8/31/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import Foundation

class Playlist {
    
    // songs in the playlist
    var songs: [MediaItem]
    
    // playlist name
    var name: String
    
    // date playlist is created
    var date: Date
    
    init(name: String, songs: [MediaItem]) {
        self.name = name
        self.songs = songs
        self.date = Date()
    }
    
}
