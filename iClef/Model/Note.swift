//
//  Note.swift
//  iClef
//
//  Created by Andrea Brugaletta on 07/04/22.
//

import Foundation
import UIKit

var lastIndex = 0
var lastClef : ClefName? = nil

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
    
    //called as soon as the game starts or for generic compound intervals
    func getRandomNote(in clefName: ClefName) -> String {
        print("getRandomInterval called")
        let notesArray = getOrderedNotes(Array(getOffsetsByClef(clefName).keys))
        let index = Int.random(in: 0..<notesArray.count) //random number in range [0, 12]
        lastIndex = index //saves the index of the very first note in a global variable
        return notesArray[index]
    }
    
    //called after the very first note is already choosen
    func getRandomNotesInterval(_ interval : Interval?, _ noteName : String, in clefName: ClefName) -> String {
        
        if let interval = interval {
            var notesArray = Array(getOffsetsByClef(clefName).keys)
            notesArray = getOrderedNotes(notesArray)

            var index = 0
            
            if (lastClef == clefName) {
                index = Int(notesArray.firstIndex(of: noteName) ?? lastIndex)
            } else {
                index = lastIndex
            }
            
            var offset = Int.random(in: 0...interval.rawValue)

            
            if index + offset > 12 && index - offset < 0 {
                offset /= 2
            }
            
            if index + offset > 12 {
                index = index - offset
            } else if index - offset < 0 {
                index = index + offset
            } else {
                let sign = Int.random(in: 0...1) == 0 ? -1 : 1
                index = index + (sign * offset)
            }
            
            lastIndex = index
            lastClef = clefName
            
            return notesArray[index]
        } else {
            return getRandomNote(in: clefName)
        }
    

    }
    
    func getRandomAccidental() -> Accidental {
        return Accidental.allCases.randomElement() ?? .natural
    }
    
    private func getOrderedNotes(_ notes : [String]) -> [String] {
        let notesArray = notes.sorted {
            let first = String($0.reversed())
            let second = String($1.reversed())
            
            if (first[0] == second[0]) {
                
                if (first[1] == "A" && second[1] != "B") {
                    return false
                }
                if (first[1] == "B" && second[1] != "A") {
                    return false
                }
                if (first[1] != "B" && second[1] == "A") {
                    return true
                }
                if (first[1] != "A" && second[1] == "B") {
                    return true
                } else {
                    return first < second
                }
            }
            
            return first < second
            
        }
        return notesArray
    }
    
    // OPTIMIZATION?: generate the probArray only when needed
    func generateRandomAccidentalFor(_ step: Int, note noteName: String) -> Accidental {
        
        var probArray : [Int] = []
        
        if step == 4 {
            print("step = \(step)")
            probArray += Array(repeating: 1, count: 3)
            probArray += Array(repeating: 2, count: 3)
            probArray += Array(repeating: 3, count: 1)
            probArray += Array(repeating: 4, count: 1)
            probArray += Array(repeating: 0, count: 2)
        } else {
            
            if !noteName.contains("F") && !noteName.contains("C") {
                probArray += Array(repeating: 1, count: step)
            }
            if !noteName.contains("E") && !noteName.contains("B") {
                probArray += Array(repeating: 2, count: step)
            }
            probArray += Array(repeating: 0, count: 10-probArray.count)
        }
        
        return Accidental(rawValue: probArray.randomElement()!)!
    }
        
}
