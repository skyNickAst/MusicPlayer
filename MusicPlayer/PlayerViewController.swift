//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by Nikolai Astakhov on 25.01.2023.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    var player: AVAudioPlayer?
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica-Bold", size: 25)!
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica-Bold", size: 25)!
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica-Bold", size: 25)!
        return label
    }()
    
    let playPauseButton = UIButton()
    
    @IBOutlet var holder: UIView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure() {
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else { return }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else { return }
            
            player.volume = 0.4
            player.play()
            
        } catch {
            print("Error to configure song/player")
        }
        albumImageView.frame = CGRect(x: 10, y: 10, width: holder.frame.size.width - 20, height: holder.frame.size.width - 20)
        songNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 20, width: holder.frame.size.width - 20, height: 50)
        albumNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 20 + 50, width: holder.frame.size.width - 20, height: 50)
        artistNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 20 + 100, width: holder.frame.size.width - 20, height: 50)
        
        albumImageView.image = UIImage(named: song.imageName)
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder.addSubview(albumImageView)
        holder.addSubview(songNameLabel)
        holder.addSubview(albumNameLabel)
        holder.addSubview(artistNameLabel)
        
        let nextButton = UIButton()
        let backButton = UIButton()
        
        let yPosition = artistNameLabel.frame.origin.y + 50 + 50
        let buttonSize: CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - buttonSize) / 2, y: yPosition, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: holder.frame.size.width - buttonSize - 20, y: yPosition, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: 20, y: yPosition, width: buttonSize, height: buttonSize)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .systemPink
        nextButton.tintColor = .systemPink
        backButton.tintColor = .systemPink
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        let slider = UISlider(frame: CGRect(x: 20, y: holder.frame.size.height - 60, width: holder.frame.size.width - 40, height: 50))
        slider.value = 0.4
        slider.tintColor = .systemPink
        slider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        holder.addSubview(slider)
        
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.stop()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30, y: 30, width: self.holder.frame.size.width - 60, height: self.holder.frame.size.width - 60)
            })
        } else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10, y: 10, width: self.holder.frame.size.width - 20, height: self.holder.frame.size.width - 20)
            })
        }
    }
    
    @objc func didTapNextButton() {
        if position < songs.count - 1 {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
