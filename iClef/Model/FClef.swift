//
//  FClef.swift
//  iClef
//
//  Created by Andrea Brugaletta on 07/04/22.
//

import Foundation

struct FClef {
    let yNoteOffsets : [String:Float]
    let symbolName : String
    
    init(name clef: String) {
        
        symbolName = clef
        
        if clef == "bass" {
            yNoteOffsets = ["E":0.924, "F":1.02, "G":1.18, "A":1.36, "B":1.65, "C":2.05, "D":2.8, "E":4.0, "F":7.8, "G":100, "A":-8, "B":-4, "C":-2.85]
        } else {
            yNoteOffsets = [:]
        }
        
    }
}
