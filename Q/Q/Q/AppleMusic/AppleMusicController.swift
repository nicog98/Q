//
//  AppleMusicController.swift
//  Q
//
//  Created by Nicolai Garcia on 7/31/18.
//  Copyright © 2018 Nicolai Garcia. All rights reserved.
//

import Foundation
import StoreKit
import Parse

class AppleMusicController {
    
    // MARK: Types
    
    /// The completion handler that is called when an Apple Music Catalog Search API call completes.
    typealias CatalogSearchCompletionHandler = (_ mediaItems: [[MediaItem]], _ error: Error?) -> Void
    
    /// The completion handler that is called when an Apple Music Get User Storefront API call completes.
    typealias GetUserStorefrontCompletionHandler = (_ storefront: String?, _ error: Error?) -> Void
    
    // MARK: Properties
    
    /// The instance of `URLSession` that is going to be used for making network calls.
    lazy var urlSession: URLSession = {
        // Configure the `URLSession` instance that is going to be used for making network calls.
        let urlSessionConfiguration = URLSessionConfiguration.default
        
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    /// The storefront id that is used when making Apple Music API calls.
    var storefrontID: String?
    
    var developerToken: String?
    
    func fetchDeveloperToken() -> String? {
        if developerToken == nil {
            let query = PFQuery(className: "DeveloperToken")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if let objects = objects {
                        let developerTokenObject = objects[0]
                        self.developerToken = developerTokenObject["developerToken"] as? String
                    }
                } else {
                    print("ERROR FETCHING DEVELOPER TOKEN: \(error!.localizedDescription)")
                }
            }
        }
        return developerToken
//        return "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlVZVVk0SEs2TlMifQ.eyJpc3MiOiJGS0JKTDM3SFBRIiwiaWF0IjoxNTMzMDg5NjQ0LCJleHAiOjE1NDg4NjEyNDR9.w7L-p--UrC98Odtnehjr1wxBeK5bKnBrVNv94C-aeLrVeC3wJT_AWrwWxV-fP97Dzs2_lIMX4nVmjbiSrI3wpQ"
    }
    
    // MARK: General Apple Music API Methods
    
    func performAppleMusicCatalogSearch(with term: String, countryCode: String, completion: @escaping CatalogSearchCompletionHandler) {
        
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured. See README for more details.")
        }
        
        let urlRequest = AppleMusicSearchGenerator.createSearchRequest(with: term, countryCode: countryCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([], error)
                return
            }
            
            do {
                let mediaItems = try self.processMediaItemSections(from: data!)
                completion(mediaItems, nil)
                
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func performAppleMusicStorefrontsLookup(regionCode: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured. See README for more details.")
        }
        
        let urlRequest = AppleMusicSearchGenerator.createStorefrontsRequest(regionCode: regionCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            do {
                let identifier = try self?.processStorefront(from: data!)
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // MARK: Personalized Apple Music API Methods
    
    func performAppleMusicGetUserStorefront(userToken: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured.  See README for more details.")
        }
        
        let urlRequest = AppleMusicSearchGenerator.createGetUserStorefrontRequest(developerToken: developerToken, userToken: userToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                let error = NSError(domain: "AppleMusicManagerErrorDomain", code: -9000, userInfo: [NSUnderlyingErrorKey: error!])
                
                completion(nil, error)
                
                return
            }
            
            do {
                
                let identifier = try self?.processStorefront(from: data!)
                
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func processMediaItemSections(from json: Data) throws -> [[MediaItem]] {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let results = jsonDictionary[ResponseRootJSONKeys.results] as? [String: [String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.results)
        }
        
        var mediaItems = [[MediaItem]]()
        
        if let songsDictionary = results[ResourceTypeJSONKeys.songs] {
            
            if let dataArray = songsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let songMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(songMediaItems)
            }
        }
        
        if let albumsDictionary = results[ResourceTypeJSONKeys.albums] {
            
            if let dataArray = albumsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let albumMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(albumMediaItems)
            }
        }
        
        return mediaItems
    }
    
    func processMediaItems(from json: [[String: Any]]) throws -> [MediaItem] {
        let songMediaItems = try json.map { try MediaItem(json: $0) }
        return songMediaItems
    }
    
    func processStorefront(from json: Data) throws -> String {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let data = jsonDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.data)
        }
        
        guard let identifier = data.first?[ResourceJSONKeys.identifier] as? String else {
            throw SerializationError.missing(ResourceJSONKeys.identifier)
        }
        
        return identifier
    }
    
}
