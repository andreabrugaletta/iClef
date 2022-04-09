//
//  GClef.swift
//  iClef
//
//  Created by Andrea Brugaletta on 06/04/22.
//

import Foundation

struct Clef {
    
    let yNoteOffsets : [String:Double]
    
    let name : ClefName
    let assetName : String
    let xOffset : Double
    let yOffset : Double
    let frameHeight : Double
    
    init(name clef: ClefName) {
        
        name = clef
        
        switch clef {
            case .treble:
                yNoteOffsets = ["C4":0.924, "D4":1.02, "E4":1.18, "F4":1.36, "G4":1.65, "A4":2.05, "B4":2.8, "C5":4.0, "D5":7.8, "E5":100, "F5":-8, "G5":-4, "A5":-2.85]
                assetName = "treble_clef"
                xOffset = -10.0
                yOffset = -2.0
                frameHeight = 2.0
            case .bass:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "f_clef"
                xOffset = 10.0
                yOffset = 100.0
                frameHeight = 0.83
            case .baritone:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "f_clef"
                xOffset = 10.0
                yOffset = 4.0
                frameHeight = 0.83
            case .tenor:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = -4.01
                frameHeight = 1.0114
            case .alto:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = -120.0
                frameHeight = 1.0114
            case .mezzoSoprano:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = 4.203
                frameHeight = 1.0114
            case .soprano:
                yNoteOffsets = ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
                assetName = "c_clef"
                xOffset = 10.0
                yOffset = 2.114
                frameHeight = 1.0114
        }
    }
}
