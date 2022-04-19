//
//  Note.swift
//  iClef
//
//  Created by Andrea Brugaletta on 07/04/22.
//

import Foundation
import UIKit

struct Note {
    var clef : ClefName
    let assetName : String
    var name : String
    let width : Double
    let height : Double
    let xOffset : Double
    
    var yOffsetsByClef : [String:Double] {
        getOffsetsByClef(clef)
    }
    var yOffset : Double {
        return yOffsetsByClef[name] ?? 0.0
    }

    init(name: String, in clef: ClefName) {
        width = 8.0
        height = 3.8
        xOffset = 2.65
        assetName = "note_head"
        self.clef = clef
        self.name = name
    }
    
    private func getOffsetsByClef(_ clef: ClefName) -> [String:Double] {
        // double-check if notes are right!
        switch clef {
            case .treble:
                return ["C4":0.924, "D4":1.02, "E4":1.18, "F4":1.36, "G4":1.65, "A4":2.05, "B4":2.8, "C5":4.0, "D5":7.8, "E5":100, "F5":-8, "G5":-4, "A5":-2.85]
            case .bass:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .baritone:
                return ["G2":0.924, "A2":1.02, "B2":1.18, "C3":1.36, "D3":1.65, "E3":2.05, "F3":2.8, "G3":4.0, "A3":7.8, "B3":100, "C4":-8, "D4":-4, "E4":-2.85]
            case .tenor:
                return ["B2":0.924, "C3":1.02, "D3":1.18, "E3":1.36, "F3":1.65, "G3":2.05, "A3":2.8, "B3":4.0, "C4":7.8, "D4":100, "E4":-8, "F4":-4, "G4":-2.85]
            case .alto:
                return ["D3":0.924, "E3":1.02, "F3":1.18, "G3":1.36, "A3":1.65, "B3":2.05, "C4":2.8, "D4":4.0, "E4":7.8, "F4":100, "G4":-8, "A4":-4, "B4":-2.85]
            case .mezzoSoprano:
                return ["F3":0.924, "G3":1.02, "A3":1.18, "B3":1.36, "C4":1.65, "D4":2.05, "E4":2.8, "F4":4.0, "G4":7.8, "A4":100, "B4":-8, "C5":-4, "D5":-2.85]
            case .soprano:
                return ["A3":0.924, "B3":1.02, "C4":1.18, "D4":1.36, "E4":1.65, "F4":2.05, "G4":2.8, "A4":4.0, "B4":7.8, "C5":100, "D5":-8, "E5":-4, "F5":-2.85]
        }
    }
    
    func getRandomNote(in clef: ClefName) -> String {
        let index = Int(arc4random_uniform(UInt32(getOffsetsByClef(clef).count)))
        return Array(getOffsetsByClef(clef).keys)[index]
    }
    
    func getRandomAccidental() -> Accidental {
        return Accidental.allCases.randomElement() ?? .natural
    }
        
}
