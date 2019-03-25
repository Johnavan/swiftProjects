//
//  Playlist.swift
//  HelloTableView
//
//  Created by Johnavan Thomas on 2019-03-25.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

import Foundation
import UIKit
class Playlist {
    var songs = [Song]()
    
    init(){
        songs.append(Song(title: "The Girl From Ipanema",
    composer: "Antonio Carlos Jobim",
    duration: nil,
    rating: nil))
    
        songs.append(Song(title: "Brown Eyed Girl",
    composer: "Van Morrison",
    duration: "3:27",
    rating: "****"))
        
        songs.append(Song(title: "Peaceful Easy Feeling",
    composer: "Jack Tempchin",
    duration: nil,
    rating: nil))
    
        songs.append(Song(title: "Hotel California",
    composer: "Don Henley, Glenn Frey",
    duration: "3:27",
    rating: "*****"))
        
        songs.append(Song(title: "Desifinado",
    composer: "Antonio Carlos Jobim",
    duration: nil,
    rating: nil))
    
        songs.append(Song(title: "Sister Golden Hair",
    composer: "America",
    duration: "3:05",
    rating: "****"))
    }

}


