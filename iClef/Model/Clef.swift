//
//  GClef.swift
//  iClef
//
//  Created by Andrea Brugaletta on 06/04/22.
//

import Foundation

struct Clef {

    let name : ClefName
    let assetName : String
    let xOffset : Double
    let yOffset : Double
    let frameHeight : Double
    
    init(name clef: ClefName) {
        
        name = clef
        
        switch clef {
            case .treble:
                assetName = "treble_clef"
                xOffset = -10.0
                yOffset = -2.0
                frameHeight = 2.0
            case .bass:
                assetName = "f_clef"
                xOffset = 10.0
                yOffset = 100.0
                frameHeight = 0.83
            case .baritone:
                assetName = "f_clef"
                xOffset = 10.0
                yOffset = 4.0
                frameHeight = 0.83
            case .tenor:
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = -4.01
                frameHeight = 1.0114
            case .alto:
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = -120.0
                frameHeight = 1.0114
            case .mezzoSoprano:
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = 4.203
                frameHeight = 1.0114
            case .soprano:
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = 2.114
                frameHeight = 1.0114
        }
    }
}
