//
//  PhotosViewController.swift
//  FlickrView
//
//  Created by Johnavan Thomas on 2019-03-27.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation
import UIKit
class PhotosViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running Fickr Viewer")
        let url = FlickrAPI.recentPhotosURL()
        print("request url:")
        print(url)
        let store = PhotoStore()
        store.fetchRecentPhotos()
    }
}
