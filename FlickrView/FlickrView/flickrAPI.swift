//
//  flickrAPI.swift
//  FlickrView
//
//  Created by Johnavan Thomas on 2019-03-27.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "f329373f765cab93f4b71d3fbbef2b83" //use our own key
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        //return URL(string: "")! //for now
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for(key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
        }
        components.queryItems = queryItems
        return components.url!
    }

    
    static func recentPhotosURL()->URL {
        return flickrURL(method: .RecentPhotos, parameters: [
            "method": Method.RecentPhotos.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey,
            "extras": "url_h,date_taken"])
    }
}



