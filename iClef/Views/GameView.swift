//
//  MainView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 02/04/22.
//

import SwiftUI

struct GameView: View {
    
    private let GAME_TIME = 5 //seconds
    private let SUB = 0.001
    private let MAX_ERRORS = 3
    
    @State var randomNote : String = "A4"
    @State var accidental : Accidental = .natural
    @State var randomClef : ClefName = .treble
    @State var notePressed : String = "none"
    @State var score =  0
    @State var errors = 0
    @State var isGameOver = false
    @State var secondsPassed = 0
    @State var hasPlayerAnswered = false
    @State var progressBarWidth : CGFloat = 300
    @State var toSec = 0

    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    
    private func startGame(_ note : Note, _ clef : Clef) {
        print("start game")
        pickRandomClefAndNote(note, clef)
    }
    
    private func pickRandomClefAndNote(_ note: Note, _ clef : Clef) {
        randomClef = clef.getRandomLvl2Clef()
        print(randomClef)
        randomNote = note.getRandomNote(in: randomClef)
        accidental = note.getRandomAccidental()
    }
    
    private func restartTimer() {
        secondsPassed = 0
        hasPlayerAnswered = false
    }
        
    private func didTimerExpired(note: Note, clef: Clef) {
        
        let p : Double = 300.0 / (Double(GAME_TIME) / SUB)
        progressBarWidth = progressBarWidth - CGFloat(p)

        if hasPlayerAnswered {
            restartTimer()
            progressBarWidth = 300.0
        }
        
        toSec += 1
        
        if toSec == Int(1.0 / SUB) {
            secondsPassed += 1
            toSec = 0
            print(secondsPassed)
        }
        
        if (secondsPassed >= GAME_TIME) {
            pickRandomClefAndNote(note, clef)
            errors += 1
            checkGameOver()
            secondsPassed = 0
            progressBarWidth = 300.0
        }
        
    }
        
    private func checkCorrectAnswer(notePressed : String, note : Note, clef: Clef) {
        
        if notePressed.contains(randomNote.first!) {
            //correct
            score += 1
        } else {
            //wrong
            print("wrong")
            errors += 1
            checkGameOver()
        }
        
        hasPlayerAnswered = true
        secondsPassed = 1
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
                .opacity(0.6)
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
                        //accidental
                        if accidental == .sharp {
                            Image("sharp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / note.width, height: geometry.size.height / 2.0, alignment: .center)
                                .offset(x: geometry.size.width / (note.xOffset * 1.3), y: (geometry.size.height / note.yOffset) - 9.2)
                        } else if accidental == .flat {
                            Image("flat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / note.width, height: geometry.size.height / 2.2, alignment: .center)
                                .offset(x: geometry.size.width / (note.xOffset * 1.32), y: (geometry.size.height / note.yOffset) - 17.5)
                        }
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
                                .offset(x: geometry.size.width / note.xOffset, y: geometry.size.height / 0.84)
                        }
                        if note.yOffset == -2.85 {
                            Rectangle()
                                .frame(width: geometry.size.width / 8, height: 3.65)
                                .offset(x: geometry.size.width / note.xOffset, y: geometry.size.height / -4.02)
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
                        
            ProgressBar(progressWidth: $progressBarWidth)
                .padding()
                .padding(.top, 20)
                       
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
            .previewDevice("iPhone 12")
            .previewInterfaceOrientation(.portrait)
    }
}
