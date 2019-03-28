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
    
    func fetchRecentPhotos(){
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8){
                    print(jsonString) //for now
                }
            } else if let requestError = error {
                print("ERROR: fetching recent photos: \(requestError)")
            } else {
                print("ERROR: unexpected error with request")
            }
        }
        task.resume()
    }
}
