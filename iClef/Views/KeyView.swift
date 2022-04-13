//
//  KeyboardView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 13/04/22.
//

import SwiftUI
import AudioKit
import AudioKitUI

struct KeyView: View {
    @Binding var notePressed : String
    
    var body: some View {
        VStack {
            Keyboard(notePressed: $notePressed)
        }

    }
}

struct Keyboard : UIViewRepresentable {
    
    @Binding var notePressed : String
    
    func makeUIView(context: Context) -> KeyboardView {
        let keyboard = KeyboardView()
        keyboard.octaveCount = 1
        keyboard.topKeyHeightRatio = 0.60
        keyboard.delegate = context.coordinator
        return keyboard
    }
    
    func updateUIView(_ uiView: KeyboardView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(notePressed: $notePressed)
    }
    
    class Coordinator : KeyboardDelegate {
        
        @Binding var notePressed : String
        
        init(notePressed: Binding<String>) {
            self._notePressed = notePressed
        }
        
        private func midiToNote(note: MIDINoteNumber) -> String? {
            switch note {
                case 72, 84:
                    return "C"
                case 74:
                    return "D"
                case 76:
                    return "E"
                case 77:
                    return "F"
                case 79:
                    return "G"
                case 81:
                    return "A"
                case 83:
                    return "B"
                default:
                    return nil
            }
        }
        
        func noteOn(note: MIDINoteNumber) {
            notePressed = midiToNote(note: note) ?? "none"
        }
        
        func noteOff(note: MIDINoteNumber) {
    
        }
        
    }
    
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(notePressed: .constant("none"))
    }
}
