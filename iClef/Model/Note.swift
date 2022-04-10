//
//  Note.swift
//  iClef
//
//  Created by Andrea Brugaletta on 07/04/22.
//

import Foundation
import UIKit

struct Note {
    
    let clef : ClefName
    let assetName : String
    let name : String
    let width : Double
    let height : Double
    let xOffset : Double
    
    var yOffsetsByClef : [String:Double] {
        switch clef {
            case .treble:
                return ["C4":0.924, "D4":1.02, "E4":1.18, "F4":1.36, "G4":1.65, "A4":2.05, "B4":2.8, "C5":4.0, "D5":7.8, "E5":100, "F5":-8, "G5":-4, "A5":-2.85]
            case .bass:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .baritone:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .tenor:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .alto:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .mezzoSoprano:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
            case .soprano:
                return ["E2":0.924, "F2":1.02, "G2":1.18, "A2":1.36, "B2":1.65, "C3":2.05, "D3":2.8, "E3":4.0, "F3":7.8, "G3":100, "A3":-8, "B3":-4, "C4":-2.85]
        }
    }
    
    var yOffset : Double {
        return yOffsetsByClef[name] ?? 0.0
    }

    init(name: String, in clef: ClefName) {
        width = 8.0
        height = 3.8
        xOffset = 2.5
        assetName = "note_head"
        self.clef = clef
        self.name = name
    }
    
    func getRandomNote() -> String {
        let index = Int(arc4random_uniform(UInt32(yOffsetsByClef.count)))
        return Array(yOffsetsByClef.keys)[index]
    }
        
}
