//
//  Artwork.swift
//  Q
//
//  Created by Nicolai Garcia on 7/31/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation

class AppleMusicArtwork: Artwork {
    
    // MARK: Types
    
    /// The various keys needed for serializing an instance of `Artwork` using a JSON response from the Apple Music Web Service.
    struct JSONKeys {
        static let height = "height"
        
        static let width = "width"
        
        static let url = "url"
    }
    
    // MARK: Initialization
    
    init(json: [String: Any]) throws {
        
        guard let height = json[JSONKeys.height] as? Int else {
            throw SerializationError.missing(JSONKeys.height)
        }
        
        guard let width = json[JSONKeys.width] as? Int else {
            throw SerializationError.missing(JSONKeys.width)
        }
        
        guard let urlTemplateString = json[JSONKeys.url] as? String else {
            throw SerializationError.missing(JSONKeys.url)
        }
        
        super.init(height: height, width: width, urlTemplateString: urlTemplateString)
    }
    
    // MARK: Image URL Generation Method
    
    override func imageURL(height: Int, width: Int) -> URL {
        
        /*
         There are three pieces of information needed to create the URL for the image we want for a given size.  This information is the width, height
         and image format.  We can use this information in addition to the `urlTemplateString` to create the URL for the image we wish to use.
         */
        
        // 1) Replace the "{w}" placeholder with the desired width as an integer value.
        var imageURLString = urlTemplateString.replacingOccurrences(of: "{w}", with: "\(width)")
        
        // 2) Replace the "{h}" placeholder with the desired height as an integer value.
        imageURLString = imageURLString.replacingOccurrences(of: "{h}", with: "\(height)")
        
        // 3) Replace the "{f}" placeholder with the desired image format.
        imageURLString = imageURLString.replacingOccurrences(of: "{f}", with: "png")
        
        return URL(string: imageURLString)!
    }
}
