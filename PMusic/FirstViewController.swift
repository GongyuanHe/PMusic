//
//  FirstViewController.swift
//  PMusic
//
//  Created by Gongyuan He on 4/23/19.
//  Copyright © 2019 Gongyuan He. All rights reserved.
//

import UIKit
import AVFoundation

var songs:[String] = []
var audioPlayer = AVAudioPlayer()
var songsLoaded:Bool = false
var selectedSongIndex = 0
var currentLyricDict:[TimeInterval: String] = [:]
var playedSongsIndex = Set<Int>()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = songs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            //Play Music
            let audioPath = Bundle.main.path(forResource: songs[indexPath.row], ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            selectedSongIndex = indexPath.row
            
            playedSongsIndex.insert(selectedSongIndex)
            
            //Set current lyric dict
            currentLyricDict = [:]
            getStringFromTxt()
            
            //Navigate to lyric view
            let tbc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
            tbc.selectedIndex = 1
            self.present(tbc, animated: true, completion: nil)
        } catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !songsLoaded {
            getSongsNames()
        }
    }
    
    func getSongsNames() {
        
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        print(folderURL)
        
        do {
            
            let songsPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys:  nil, options: .skipsHiddenFiles)
            
            for song in songsPath {
                
                var mySong = song.absoluteString
                mySong = mySong.components(separatedBy: "/").last ?? ""
                if mySong.contains(".mp3") {
                    mySong = mySong.removingPercentEncoding!
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songs.append(mySong)
                }
            }
            songsLoaded = true
            myTableView.reloadData()
            
        } catch {
            
        }
    }

}
