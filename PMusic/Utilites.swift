//
//  Utilites.swift
//  PMusic
//
//  Created by Gongyuan He on 4/24/19.
//  Copyright © 2019 Gongyuan He. All rights reserved.
//

import Foundation

func getStringFromTxt() {
    let lyricPath = Bundle.main.path(forResource: songs[selectedSongIndex], ofType: ".txt")
    do {
        var res = ""
        res = try String(contentsOfFile: lyricPath!)
        convertLyricStringToDict(lyricStr: res)
    } catch {
        
    }
}

func convertLyricStringToDict(lyricStr: String) {
    let stringArray = lyricStr.components(separatedBy: "\n")
    for row in stringArray {
        if row != "" {
            let rowArray = row.components(separatedBy: "]")
            let timeString = rowArray[0].replacingOccurrences(of: "[", with: "")
            currentLyricDict[parseDuration(timeString).rounded()] = rowArray[1]
        }
    }
}

func parseDuration(_ timeString:String) -> TimeInterval {
    guard !timeString.isEmpty else {
        return 0
    }
    
    var interval:Double = 0
    
    let parts = timeString.components(separatedBy: ":")
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    return interval
}

func getRandomIndex() -> Int {
    let number = Int.random(in: 0 ..< songs.count)
    return number
}
