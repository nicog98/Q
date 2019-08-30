//
//  MediaItem.swift
//  Q
//
//  Created by Nicolai Garcia on 7/31/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation

class AppleMusicMediaItem: MediaItem {
    
    // MARK: Types
    
    /// The various keys needed for serializing an instance of `MediaItem` using a JSON response from the Apple Music Web Service.
    struct JSONKeys {
        static let identifier = "id"
        
        static let type = "type"
        
        static let attributes = "attributes"
        
        static let name = "name"
        
        static let artistName = "artistName"
        
        static let artwork = "artwork"
    }
    
    // MARK: Initialization
    
    init(json: [String: Any]) throws {
        guard let identifier = json[JSONKeys.identifier] as? String else {
            throw SerializationError.missing(JSONKeys.identifier)
        }
        
        guard var typeString = json[JSONKeys.type] as? String else {
            throw SerializationError.missing(JSONKeys.type)
        }
        typeString.removeLast() // Apple Music encodes the type parameter with a trailing 's', remove it so it conforms with the MediaItem.MediaType parameter
        
        guard let attributes = json[JSONKeys.attributes] as? [String: Any] else {
            throw SerializationError.missing(JSONKeys.attributes)
        }
        
        guard let name = attributes[JSONKeys.name] as? String else {
            throw SerializationError.missing(JSONKeys.name)
        }
        
        let artistName = attributes[JSONKeys.artistName] as? String ?? " "
        
        guard let artworkJSON = attributes[JSONKeys.artwork] as? [String: Any], let artwork = try? AppleMusicArtwork(json: artworkJSON) else {
            throw SerializationError.missing(JSONKeys.artwork)
        }
        
        super.init(identifier: identifier, typeString: typeString, name: name, artistName: artistName, artwork: artwork)
    }
}
