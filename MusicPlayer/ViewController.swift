//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Nikolai Astakhov on 25.01.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        configureSongs()
    }
    
    func configureSongs() {
        songs.append(Song(name: "Hell", albumName: "The Lost Children", artistName: "Disturbed", imageName: "hell.jpeg", trackName: "Disturbed_Hell"))
        songs.append(Song(name: "The Light", albumName: "Immortalized", artistName: "Disturbed", imageName: "light.jpeg", trackName: "Disturbed_The_Light"))
        songs.append(Song(name: "Warrior", albumName: "Indestructible", artistName: "Disturbed", imageName: "warrior.png", trackName: "Disturbed_Warrior"))
        songs.append(Song(name: "Hell", albumName: "The Lost Children", artistName: "Disturbed", imageName: "hell.jpeg", trackName: "Disturbed_Hell"))
        songs.append(Song(name: "The Light", albumName: "Immortalized", artistName: "Disturbed", imageName: "light.jpeg", trackName: "Disturbed_The_Light"))
        songs.append(Song(name: "Warrior", albumName: "Indestructible", artistName: "Disturbed", imageName: "warrior.png", trackName: "Disturbed_Warrior"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
        content.text = song.name
        content.secondaryText = song.albumName
        content.textProperties.font = UIFont(name: "Helvetica-Bold", size: 18)!
        content.secondaryTextProperties.font = UIFont(name: "Helvetica", size: 17)!
        content.image = UIImage(named: song.imageName)
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else { return }
        vc.songs = songs
        vc.position = position
        
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct Song {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
