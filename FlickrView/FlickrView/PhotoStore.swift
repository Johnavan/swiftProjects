//
//  PhotoStore.swift
//  FlickrView
//
//  Created by Johnavan Thomas on 2019-03-27.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchRecentPhotos(completion: @escaping (PhotoResult) ->Void){
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }

    
    func processRecentPhotosRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data
            else {
                return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
