//
//  MainView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 02/04/22.
//

import SwiftUI

struct StaffView: View {    
    @State var randomNote : String = "C4"
    @State var randomClef : ClefName = .treble
    @State var notePressed : String = "none"
    
    @State var isTimerRunning = true
    @State var isPlayerRight = false
    @State var score =  0
    @State var errors = 0
    @State var count = 0
    @State var isGameOver = false
    @State var isButtonDisabled = false
    
    let notes = ["C", "C#/Db", "D", "D#/Eb", "E", "F","F#/Gb", "G","G#/Ab", "A", "A#/Bb", "B"]
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    /*
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private func gameOver() {
        isTimerRunning.toggle()
        isGameOver.toggle()
        isButtonDisabled.toggle()
    }
    private func pickRandomNote() {
        let index = Int(arc4random_uniform(UInt32(note.yOffsetsByClef.count)))
        let randomValue = Array(note.yOffsetsByClef.keys)[index]
        randomNote = randomValue
    }
    */
    
    var body: some View {
        
        let note = Note(name: randomNote, in: randomClef)
        let clef = Clef(name: randomClef)
        
        VStack {
            //staff
            Image("staff")
                .resizable()
                .scaledToFit()
                .opacity(0.8)
                .overlay {
                    GeometryReader { geometry in
                        //clef
                        Image(clef.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * clef.frameHeight)
                            .offset(x: geometry.frame(in: .local).origin.x + clef.xOffset,
                                    y: geometry.size.height / clef.yOffset)
                        //note
                        Image(note.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / note.width,
                                   height: geometry.size.height / note.height,
                                   alignment: .center)
                            .offset(x: geometry.size.width / note.xOffset,
                                    y: geometry.size.height / note.yOffset)
                        // dash (for dashed notes)
                        if note.yOffset == 0.924 {
                            Rectangle()
                                .frame(width: geometry.size.width / 8, height: 3.65)
                                .offset(x: geometry.size.width / 2.5, y: geometry.size.height / 0.84)
                        }
                        if note.yOffset == -2.85 {
                            Rectangle()
                                .frame(width: geometry.size.width / 8, height: 3.65)
                                .offset(x: geometry.size.width / 2.5, y: geometry.size.height / -4.02)
                        }
                    }
                }
            .frame(width: 350, height: 130, alignment: .leading)
            .onReceive(timer) { _ in
                randomClef = clef.getRandomClef()
                randomNote = note.getRandomNote(in: randomClef)
            }
            
            Text("note \(randomNote)")
                .padding(.top, 40)
            /*
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
             */
            
    //button keyboard
    /*
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
     */
            
            Text("note pressed: \(notePressed)")
            
            KeyView(notePressed: $notePressed)
                .frame(height: 250)
                .padding(.horizontal, 24)
            
            Spacer()
            
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

struct StaffView_Previews: PreviewProvider {
    static var previews: some View {
        StaffView()
            .previewDevice("iPhone 13 Pro Max")
            .previewInterfaceOrientation(.portrait)
    }
}
