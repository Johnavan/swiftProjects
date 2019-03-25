//
//  Song.swift
//  HelloTableView
//
//  Created by Johnavan Thomas on 2019-03-25.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation
import UIKit

class Song: NSObject {
    var title: String //e.g. "Girl From Ipanema, The"
    var composer: String //e.g. "Antonio Carlos Jobim"
    var duration: String? //e.g. "2:47"
    var rating: String? //"*" ... "*****"
    
    init(title: String, composer: String, duration: String?, rating: String?){
        self.title = title
        self.composer = composer
        self.duration = duration
        self.rating = rating
        
        super.init()
    }
}
