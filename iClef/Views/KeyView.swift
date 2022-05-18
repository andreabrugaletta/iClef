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
    @Binding var keyOnColor : Color
    
    var body: some View {
        VStack {
            Keyboard(notePressed: $notePressed, keyOnColor: $keyOnColor)
        }

    }
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView(notePressed: .constant("none"), keyOnColor: .constant(.white))
    }
}
