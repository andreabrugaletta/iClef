//
//  MainView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 02/04/22.
//

import SwiftUI

struct GameView: View {
    
    private let GAME_TIME = 5 //seconds
    private let MAX_ERRORS = 5
    
    @State var randomNote : String = "C4"
    @State var randomClef : ClefName = .treble
    @State var notePressed : String = "none"
    @State var score =  0
    @State var errors = 0
    @State var isGameOver = false
    @State var secondsPassed = 0
    @State var hasPlayerAnswered = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func startGame(_ note : Note, _ clef : Clef) {
        print("start game")
        pickRandomClefAndNote(note, clef)
    }
    
    private func pickRandomClefAndNote(_ note: Note, _ clef : Clef) {
        randomClef = clef.getRandomLvl2Clef()
        print(randomClef)
        randomNote = note.getRandomNote(in: randomClef)
    }
    
    private func restartTimer() {
        secondsPassed = 0
        hasPlayerAnswered = false
    }
    
    private func didTimerExpired(note: Note, clef: Clef) {
        
        if hasPlayerAnswered {
            restartTimer()
        }
        
        secondsPassed += 1
        if (secondsPassed > GAME_TIME) {
            errors += 1
            checkGameOver()
            pickRandomClefAndNote(note, clef)
            secondsPassed = 1
        }
        print(secondsPassed)
        
    }
        
    private func checkCorrectAnswer(notePressed : String, note : Note, clef: Clef) {
        
        if randomNote.contains(notePressed) {
            //correct
            score += 1
            hasPlayerAnswered = true
        } else {
            //wrong
            errors += 1
            checkGameOver()
            
        }
        pickRandomClefAndNote(note, clef)
    }
    
    private func checkGameOver() {
        if errors >= MAX_ERRORS {
            isGameOver = true
        }
    }
    
    
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
            .onAppear {
                startGame(note, clef)
            }
            .onReceive(timer) { _ in
                if !isGameOver {
                    didTimerExpired(note: note, clef: clef)
                }
            }
            
//            Text("note \(randomNote)")
//                .padding(.top, 40)
           
            KeyView(notePressed: $notePressed)
                .padding()
                .onChange(of: self.notePressed) { notePressed in
                    print(notePressed)
                    checkCorrectAnswer(notePressed: notePressed, note: note, clef: clef)
                }
            
            VStack {
                Text("Score: \(score)")
                Text("Errors: \(errors)")
            }
            .padding()
            
            if isGameOver {
                Text("GAME OVER")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding()
            }
            
        }
        .padding(.top, 44)
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewDevice("iPhone 13 Pro Max")
            .previewInterfaceOrientation(.portrait)
    }
}
