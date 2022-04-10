//
//  NoteView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 10/04/22.
//

import SwiftUI

struct NoteView: View {
    
    @State var geometry : GeometryProxy?
    @Binding var randomNote : String
    @Binding var randomClef : ClefName
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let note = Note(name: randomNote, in: randomClef)

        if let geometry = geometry {
            Image(note.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width / note.width,
                       height: geometry.size.height / note.height,
                       alignment: .center)
                .offset(x: geometry.size.width / note.xOffset,
                        y: geometry.size.height / note.yOffset)
                .onReceive(timer) { _ in
                    randomNote = note.getRandomNote()
                }
        } else {
            Text("geometry is nil")
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(geometry: nil, randomNote: .constant("C4"), randomClef: .constant(.treble))
    }
}
