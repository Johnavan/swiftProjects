//
//  PlaylistViewController.swift
//  HelloTableView
//
//  Created by Johnavan Thomas on 2019-03-25.
//  Copyright © 2019 Johnavan Thomas. All rights reserved.
//

//import Foundation
import UIKit
class PlaylistViewController: UITableViewController {
    var playlist: Playlist!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return playlist.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "UITableViewCell")
        let song = playlist.songs[indexPath.row]
        cell.textLabel?.text = song.title
        cell.detailTextLabel?.text = song.composer
        return cell
    }
}
