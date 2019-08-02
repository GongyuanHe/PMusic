//
//  SecondViewController.swift
//  PMusic
//
//  Created by Gongyuan He on 4/23/19.
//  Copyright © 2019 Gongyuan He. All rights reserved.
//

import UIKit
import AVFoundation

var myTimer: Timer?
var isSingleLoop = false

class SecondViewController: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var myLyricCol1: UILabel!
    @IBOutlet weak var myModeButton: UIButton!
    
    @IBAction func onNextTapped(_ sender: Any) {
        selectedSongIndex = selectRandomNextIndex()
        songName.text = songs[selectedSongIndex]
        myLyricCol1.text = "PMusic"
        
        let audioPath = Bundle.main.path(forResource: songs[selectedSongIndex], ofType: ".mp3")
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer.play()
            
            //Set current lyric dict
            currentLyricDict = [:]
            getStringFromTxt()
        } catch {
            
        }
    }
    
    @IBAction func onModeSelect(_ sender: Any) {
        isSingleLoop = !isSingleLoop
        setModeTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songName.text = songs[selectedSongIndex]
        setLyricCol1()
        setModeTitle()
        
        if myTimer != nil {
            myTimer!.invalidate()
            myTimer = nil
        }
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(syncLyricWithTime), userInfo: nil, repeats: true)
        
    }

    func setLyricCol1() {
        let Str = "PMusic"
//        let res = addNewLineForBetweenEachChar(str: Str)
        let res = Str
        myLyricCol1.numberOfLines = 0
        myLyricCol1.text = res
        myLyricCol1.sizeToFit()
    }
    
//    func addNewLineForBetweenEachChar(str: String) -> String {
//        var res = ""
//        for i in 1...str.count {
//            let index = str.index(str.startIndex, offsetBy: i-1)
//            res = res + "\(str[index])" + "\n"
//        }
//        return res
//    }
    
    @objc func syncLyricWithTime() {
        
        if audioPlayer.isPlaying {
            if let val = currentLyricDict[audioPlayer.currentTime.rounded()] {
                myLyricCol1.text = val
            }
        } else {
            //Play Music
            if !isSingleLoop {
                selectedSongIndex = selectRandomNextIndex()
            }
            songName.text = songs[selectedSongIndex]
            myLyricCol1.text = "PMusic"
            
            let audioPath = Bundle.main.path(forResource: songs[selectedSongIndex], ofType: ".mp3")
            do {
                
                try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
                audioPlayer.play()
                
                //Set current lyric dict
                currentLyricDict = [:]
                getStringFromTxt()
            } catch {
                
            }
        }
    }
    
    func setModeTitle() {
        if isSingleLoop {
            myModeButton.setTitle("Repeat", for: .normal)
        } else {
            myModeButton.setTitle("Loop", for: .normal)
        }
    }
    
    func selectRandomNextIndex() -> Int {
        var nextIndex = getRandomIndex()
        guard songs.count == playedSongsIndex.count else {
            let songsPlayed = playedSongsIndex.count
            while playedSongsIndex.count == songsPlayed {
                nextIndex = getRandomIndex()
                playedSongsIndex.insert(nextIndex)
            }
            return nextIndex
        }
        playedSongsIndex = [getRandomIndex()]
        return nextIndex
    }

}

