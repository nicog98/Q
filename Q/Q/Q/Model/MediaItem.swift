//
//  MediaItem.swift
//  Q
//
//  Created by Nicolai Garcia on 1/2/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import Foundation

class MediaItem {
    
    /// The catalog this MediaItem is from
    ///
    /// - appleMusic: Indicates this MediaItem is a song from the Apple Music Catalog
    /// - spotify: Indicates this MediaItem is a song from the Spotify Catalog
    /// - soundCloud: Indicates this MediaItem is a song from the SoundCloud Catalog
    enum Catalog {
        case appleMusic, spotify, soundCloud
    }
    
    enum MediaType: String {
        case song, album, playlist
    }
    
    // MARK: Properties
    
    /// How this item is identified in its music catalog
    var identifier: String
    
    /// The name of this item
    var name: String
    
    /// The artist's name
    var artistName: String
    
    /// The type of the MediaItem
    var type: MediaType
    
    /// The tracks associated with this MediaItem if it is an album or playlist
    var tracks: [MediaItem]?
    
    /// The artwork associated with this MediaItem
    var artwork: Artwork
    
    // MARK: Initialization
    
    init(identifier: String, typeString: String, name: String, artistName: String, artwork: Artwork) {
        self.identifier = identifier
        self.type = MediaType(rawValue: typeString)!
        self.name = name
        self.artistName = artistName
        self.artwork = artwork
    }
    
}
