//
//  MainView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 02/04/22.
//

import SwiftUI

struct StaffView: View {
    // upload project on github
    // download Xcode 13.3(13E113)
    
    @State var randomNote : String = "C4"
    @State var isTimerRunning = true
    @State var isPlayerRight = false
    @State var score =  0
    @State var errors = 0
    @State var count = 0
    @State var isGameOver = false
    @State var isButtonDisabled = false
    
    private let SECONDS = 3

    private let clef = Clef(name: .treble)
    private let note = Note()
    private let notes = ["C", "C#/Db", "D", "D#/Eb", "E", "F","F#/Gb", "G","G#/Ab", "A", "A#/Bb", "B"]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private func gameOver() {
        isTimerRunning.toggle()
        isGameOver.toggle()
        isButtonDisabled.toggle()
    }
    
    private func pickRandomNote() {
        let index = Int(arc4random_uniform(UInt32(clef.yNoteOffsets.count)))
        let randomValue = Array(clef.yNoteOffsets.keys)[index]
        randomNote = randomValue
    }
    
    var body: some View {
        VStack {
            Image("staff")
                .resizable()
                .scaledToFit()
                .opacity(0.8)
                .overlay {
                    GeometryReader { geometry in
                        Image(clef.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * clef.frameHeight)
                            .offset(x: geometry.frame(in: .local).origin.x + clef.xOffset,
                                    y: geometry.size.height / clef.yOffset)
                        if let yNoteOffset = clef.yNoteOffsets[randomNote] {
                            Image(note.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / note.width,
                                       height: geometry.size.height / note.height,
                                       alignment: .center)
                                .offset(x: geometry.size.width / note.xOffset,
                                        y: geometry.size.height / yNoteOffset)
                        }

                        // adding dash to notes
                        if randomNote == "C4" {
                            Rectangle()
                                .frame(width: geometry.size.width / 8, height: 3.65)
                                .offset(x: geometry.size.width / 2.5, y: geometry.size.height / 0.84)
                        }
                        if randomNote == "A5" {
                            Rectangle()
                                .frame(width: geometry.size.width / 8, height: 3.65)
                                .offset(x: geometry.size.width / 2.5, y: geometry.size.height / -4.02)
                        }
                    }
                }
            .padding()
            .frame(width: 350, height: 130, alignment: .leading)
            .onReceive(timer) { _ in
                if isTimerRunning {
                    if isPlayerRight {
                        count = 1
                        isPlayerRight = false
                    } else {
                        if count == SECONDS {
                            errors += 1
                            if errors >= 3 {
                                gameOver()
                            } else {
                                pickRandomNote()
                                count = 1
                            }
                        } else {
                            count += 1
                        }
                    }
                }
            }
            
            HStack {
                ForEach(notes, id: \.self) { note in
                    Button {
                        if randomNote.contains(note) {
                            pickRandomNote()
                            score += 1
                            isPlayerRight = true
                        } else {
                            errors += 1
                            if errors >= 3 {
                                gameOver()
                            }
                        }
                    } label: {
                        Text("\(note)")
                    }
                    .disabled(isButtonDisabled)
                }
            }
            .padding(60)
                        
            VStack {
                Text("Score: \(score)")
                Text("Errors: \(errors)")
            }
            .padding()
            
            if isGameOver {
                Text("GAME OVER")
                    .padding()
            }
            
            Spacer()
        }
        .padding(.top, 44)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        StaffView()
            .previewDevice("iPhone 8")
            .previewInterfaceOrientation(.portrait)
    }
}
