//
//  Artwork.swift
//  Q
//
//  Created by Nicolai Garcia on 1/2/19.
//  Copyright © 2019 Nicolai Garcia. All rights reserved.
//

import Foundation

class Artwork {
    
    /// Holds the Catalog this artwork is coming from
    ///
    /// - appleMusic: Indicates this artwork is coming from Apple Music
    /// - spotify: Indicates this artwork is coming from Spotify
    /// - soundCloud: Indicates this artwork is coming from SoundCloud
    enum Catalog {
        case appleMusic, spotify, soundcloud
    }
    
    /// MARK: Properties
    
    /// The maximum height available for the image
    var height: Int
    
    /// The maximum width available for the image
    var width: Int
    
    /** The template URL used to fetch the image from its catalog, the base for use in function imageURL */
    var urlTemplateString: String
    
    init(height: Int, width: Int, urlTemplateString: String) {
        self.height = height
        self.width = width
        self.urlTemplateString = urlTemplateString
    }
    
    /// MARK: Method to generate image URL needed to fetch image from its catalog
    
    func imageURL(height: Int, width: Int) -> URL {
        return URL(string: "")!
    }
    
}
