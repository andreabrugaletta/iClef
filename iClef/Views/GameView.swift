//
//  MainView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 02/04/22.
//

import SwiftUI
import AVFoundation

var audioPlayer : AVAudioPlayer?

struct GameView: View {
    
    private let MAX_ERRORS = 3
    private let ANIMATION_TIME = 120
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSettings = UserSettings()
    @State var timeToAnswer = 8.0 //seconds
    @State var level : Int?
    @State var randomNote : String = "C4"
    @State var accidental : Accidental = .natural
    @State var randomClef : ClefName = .treble
    @State var interval : Int = 1
    @State var notePressed : String = "none"
    @State var score =  0
    @State var errors = 0
    @State var isGameOver = false
    @State var progressBarWidth : CGFloat = 0
    @State var noteColor : Color = Color("customBlack")
    @State var keyOnColor : Color = .gray
    @State var randomNoteAppearingTime : Date?
    @State var playingTime : Date?
    @State var stepTime = 45.0
    @State var currentStep = 0
    @State var correctAnsweringTimes : [Double] = []
    @State var answeringTime = 0.0
    @State var answerStreak = 0
    @State var bonus = 10
    @State var isNoteAnimated : Bool = false
    @State var isClefAnimated : Bool = false
    @State var hasGameStarted : Bool = false
    @State var timePassedDecrement : Double = -0.8

    let gameplayTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let stepsTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let progressBarTimer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    private func goToLevelsView() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    //called when user answers
    private func analyzeAndAdaptGameplay(answer isCorrect : Bool) {
        if let randomNoteAppearingTime = randomNoteAppearingTime {
            let answeringTime = randomNoteAppearingTime.distance(to: Date())
            self.answeringTime = Double(answeringTime)
            
            if isCorrect {
                correctAnsweringTimes.append(answeringTime)
                /* SCORE SYSTEM */
                var increment = (Int((1.0/answeringTime).rounded()) + Int(8.0 - timeToAnswer) + 1) * (level! * level!)
                print("accidental: \(accidental)")
                if accidental != .natural {
                    print("accidental: \(accidental)")
                    if accidental == .doubleFlat || accidental == .doubleSharp {
                        increment += (currentStep * 2)
                    } else {
                        increment += currentStep
                    }
                }
                                
                if currentStep >= 1 {
                    print("CURRENT STEP >= 1")
                    answerStreak += 1
                    
                    /* more points? */
                    if answerStreak > bonus {
                        print("ANSWER STREAK!")
                        increment *= (bonus * level! * (Int(8.0 - timeToAnswer) + 1))
                        answerStreak = 0
                    }
                }
                
                score += increment
                
            } else {
                correctAnsweringTimes.removeAll()
                answerStreak = 0
            }
            
            if correctAnsweringTimes.count >= Int(timeToAnswer) {
                //calculate mean
                let sum = correctAnsweringTimes.reduce(0, +)
                let averageTime = sum / Double(correctAnsweringTimes.count)
                
                var sign = -1.0
                if timeToAnswer == 1.0 {
                    sign = 3.0 //give bonus time if the game is fast
                }
                
                if averageTime <= (timeToAnswer/10.0) {
                    stepTime += sign * 5.0 * (4.0/Double(level!))
                    if interval < 8 {
                        interval += 1
                    }
                } else if averageTime <= (timeToAnswer/8.0) {
                    stepTime += sign * 4.0 * (4.0/Double(level!))
                } else if averageTime <= (timeToAnswer/4.0) {
                    stepTime += sign * 3.0 * (4.0/Double(level!))
                } else if averageTime <= (timeToAnswer/2.0) {
                    stepTime += sign * 2.0 * (4.0/Double(level!))
                }
                
                if stepTime < 0 {
                    stepTime = 0
                }
                
                correctAnsweringTimes.removeAll()
            }
            
            
        }
    }
    
    private func colorChange(wrongAnswer isWrong : Bool) {
        if isWrong {
            noteColor = .red
        } else {
            noteColor = .green
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ANIMATION_TIME)) {
            noteColor = Color("customBlack")
        }
    }
    
    private func startGame(_ note : Note, _ clef : Clef) {
        playingTime = Date()
        pickRandomClefAndNote(in: nil, note, clef)
        withAnimation(Animation.easeIn(duration: 1.0)) {
            progressBarWidth = 300
        }
        withAnimation(Animation.easeIn(duration: 1.0)) {
            isNoteAnimated = true
        }
        withAnimation(Animation.spring(dampingFraction: 0.75, blendDuration: 1)) {
            isClefAnimated = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            hasGameStarted = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(timeToAnswer))) {
            timePassedDecrement = 0.0
        }
    }
    
    private func restartGame(_ note : Note, _ clef : Clef)  {
        keyOnColor = .gray
        notePressed = "none"
        timeToAnswer = 8.0 //seconds
        interval = 1
        score =  0
        errors = 0
        progressBarWidth = 0
        noteColor = Color("customBlack")
        stepTime = 45.0
        currentStep = 0
        correctAnsweringTimes = []
        answeringTime = 0.0
        answerStreak = 0
        bonus = 10
        isNoteAnimated = false
        isClefAnimated = false
        startGame(note, clef)
    }
    
//    private func pickRandomClefAndNote(_ note: Note, _ clef : Clef) {
//        randomNoteAppearingTime = Date() //needed for calculating answering time
//        randomClef = clef.getRandomClefByLevel(level ?? 1)
//        randomNote = note.getRandomNote(in: randomClef)
//        accidental = note.generateRandomAccidentalFor(currentStep, note: randomNote)
//    }
    
    private func pickRandomClefAndNote(in interval: Interval?, _ note: Note, _ clef : Clef) {
        randomNoteAppearingTime = Date() //needed for calculating answering time
        randomClef = clef.getRandomClefByLevel(level ?? 1)
        randomNote = note.getRandomNotesInterval(interval, randomNote, in: randomClef)
        accidental = note.generateRandomAccidentalFor(currentStep, note: randomNote)
    }
                
    private func didTimerExpired(timerDate: Date, note: Note, clef: Clef) {
        
        if let randomNoteAppearingTime = randomNoteAppearingTime {
            
            var timePassed = randomNoteAppearingTime.distance(to: timerDate)
            timePassed += timePassedDecrement
            
            print("TIME PASSED: \(timePassed)")
            
            if timePassed.rounded() >= timeToAnswer {
                playSound("wrong")
                colorChange(wrongAnswer: true)
                pickRandomClefAndNote(in: Interval(rawValue: interval)!, note, clef)
                progressBarWidth = 300.0
                errors += 1
                checkGameOver()
            }
        }
    }
    
    private func createCorrectFlatNoteFileName(_ noteName : String) -> String {
        var fileName = ""
        if noteName.contains("F") {
            fileName = "note E" + String(noteName[1])
        } else if noteName.contains("C") {
            fileName = "note B" + String(noteName[1].wholeNumberValue! - 1)
        } else {
            fileName = "note " + noteName + "b"
        }
        return fileName
    }
    
    private func createCorrectSharpNoteFileName(_ noteName : String) -> String {
        var fileName = ""
        if noteName.contains("E") {
            fileName = "note F" + String(noteName[1])
        } else if noteName.contains("B") {
            fileName = "note C" + String(noteName[1].wholeNumberValue! + 1)
        } else {
            fileName = "note " + noteName + "#"
        }
        return fileName
    }
    
    private func createCorrectNoteFileName(_ noteName : String) -> String {
        let noteNames = ["C", "D", "E", "F", "G", "A", "B"]
        var fileName = ""
            
        switch accidental {
            case .natural:
                fileName = "note " + noteName
            case .flat:
                fileName = createCorrectFlatNoteFileName(noteName)
            case .sharp:
                fileName = createCorrectSharpNoteFileName(noteName)
            case .doubleFlat:
                if noteName.contains("F") || noteName.contains("C") {
                    let startingIndex = Int(noteNames.firstIndex(of: String(noteName[0])) ?? 0)
                    let newNoteName = noteNames[(startingIndex - 1 + noteNames.count) % noteNames.count] + String(noteName[1])
                    fileName = createCorrectFlatNoteFileName(newNoteName)
                    print("FILENAME: \(fileName)")
                } else {
                    let startingIndex = Int(noteNames.firstIndex(of: String(noteName[0])) ?? 0)
                    let newNoteName = noteNames[(startingIndex - 1 + noteNames.count) % noteNames.count] + String(noteName[1])
                    fileName = "note " + newNoteName
                    print("FILENAME: \(fileName)")
                }
            case .doubleSharp:
                if noteName.contains("E") || noteName.contains("B") {
                    let startingIndex = Int(noteNames.firstIndex(of: String(noteName[0])) ?? 0)
                    let newNoteName = noteNames[(startingIndex + 1) % noteNames.count] + String(noteName[1])
                    fileName = createCorrectSharpNoteFileName(newNoteName)
                    print("FILENAME: \(fileName)")
                } else {
                    let startingIndex = Int(noteNames.firstIndex(of: String(noteName[0])) ?? 0)
                    let newNoteName = noteNames[(startingIndex + 1) % noteNames.count] + String(noteName[1])
                    fileName = "note " + newNoteName
                    print("FILENAME: \(fileName)")
                }
        }
        return fileName
    }
        
    private func checkCorrectAnswer(notePressed : String, note : Note, clef: Clef) {
                
        var isCorrect = false
        var noteName = String(randomNote[0])
        
        switch accidental {
            case .natural:
                break
            case .flat:
                noteName = noteName + "b"
            case .sharp:
                noteName = noteName + "#"
            case .doubleFlat:
                noteName = noteName + "bb"
            case .doubleSharp:
                noteName = noteName + "##"
        }
        
        let notesPressed = notePressed.components(separatedBy: " ")
    
//        print("notePressed: \(notePressed)")
//        print("notesPressed: \(notesPressed)")
//        print("noteName: \(noteName)")
        
        if String(notesPressed[0]) == noteName || String(notesPressed[1]) == noteName || String(notesPressed[2]) == noteName {
            //correct
            let fileName = createCorrectNoteFileName(randomNote)
            playSound(fileName)
            isCorrect = true
            colorChange(wrongAnswer: false)
        } else {
            //wrong
            playSound("wrong")
            errors += 1
            checkGameOver()
            colorChange(wrongAnswer: true)
        }
        
        progressBarWidth = 300.0
        analyzeAndAdaptGameplay(answer: isCorrect)
        pickRandomClefAndNote(in: Interval(rawValue: interval)!, note, clef)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ANIMATION_TIME)) {
//            pickRandomClefAndNote(in: Interval(rawValue: interval)!, note, clef)
//        }
    }
    
    private func checkGameOver() {
        if errors >= MAX_ERRORS {
            //to fix a graphic problem on keyboard
            if String(notePressed[1]) == "#" {
                keyOnColor = .black
            } else {
                keyOnColor = .white
            }

            if score > userSettings.highestScore {
                userSettings.highestScore = score
            }
            isGameOver = true
        }
    }
    
    var body: some View {
        
        let note = Note(name: randomNote, in: randomClef)
        let clef = Clef(name: randomClef)
        
        ZStack {
            Color("cream")
                .ignoresSafeArea(.all)
            VStack {
                //staff
                Image("staff")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        GeometryReader { geometry in
                            //clef
                            Image(clef.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: geometry.size.height * clef.frameHeight)
                                .offset(x: geometry.frame(in: .local).origin.x + clef.xOffset,
                                        y: geometry.size.height / clef.yOffset + (isClefAnimated ? 0 : -250))
                            //note
                            //accidental
                            switch accidental {
                                case .natural:
                                    EmptyView()
                                case .flat:
                                    Image("flat")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(noteColor)
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / note.width, height: geometry.size.height / 2.2, alignment: .center)
                                        .offset(x: geometry.size.width / (note.xOffset * 1.32), y: (geometry.size.height / note.yOffset) - 17.5)
                                case .sharp:
                                    Image("sharp")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(noteColor)
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / note.width, height: geometry.size.height / 2.0, alignment: .center)
                                        .offset(x: geometry.size.width / (note.xOffset * 1.3), y: (geometry.size.height / note.yOffset) - 9.2)
                                case .doubleFlat:
                                    Image("double_flat")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(noteColor)
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / note.width, height: geometry.size.height / 2.2, alignment: .center)
                                        .offset(x: geometry.size.width / (note.xOffset * 1.4), y: (geometry.size.height / note.yOffset) - 16)
                                case .doubleSharp:
                                    Image("double_sharp")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(noteColor)
                                        .scaledToFit()
                                        .frame(width: geometry.size.width / note.width, height: geometry.size.height / 4, alignment: .center)
                                        .offset(x: geometry.size.width / (note.xOffset * 1.38), y: (geometry.size.height / note.yOffset))
                            }
                            //note
                            Image(note.assetName)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(noteColor)
                                .scaledToFit()
                                .frame(width: geometry.size.width / note.width,
                                       height: geometry.size.height / note.height,
                                       alignment: .center)
                                .offset(x: geometry.size.width / note.xOffset + (isNoteAnimated ? 0 : 250),
                                        y: geometry.size.height / note.yOffset)
                            // dash (for dashed notes)
                            if note.yOffset == 0.924 {
                                Rectangle()
                                    .foregroundColor(noteColor)
                                    .frame(width: geometry.size.width / 8, height: 3.65)
                                    .offset(x: geometry.size.width / note.xOffset + (isNoteAnimated ? 0 : 250), y: geometry.size.height / 0.84)
                            }
                            if note.yOffset == -2.85 {
                                Rectangle()
                                    .foregroundColor(noteColor)
                                    .frame(width: geometry.size.width / 8, height: 3.65)
                                    .offset(x: geometry.size.width / note.xOffset + (isNoteAnimated ? 0 : 250), y: geometry.size.height / -4.02)
                            }
                        }
                    }
                    .frame(width: 350, height: 130, alignment: .leading)
                    .onAppear {
                        startGame(note, clef)
                    }
                    .onDisappear {
                        stepsTimer.upstream.connect().cancel()
                        gameplayTimer.upstream.connect().cancel()
                        progressBarTimer.upstream.connect().cancel()
                    }
                    .onReceive(gameplayTimer) { timerDate in
                        if !isGameOver {
                            didTimerExpired(timerDate: timerDate, note: note, clef: clef)
                        }
                    }
                    .onReceive(stepsTimer) { currentDate in
                        if let playingTime = playingTime {
                            
                            let distance = playingTime.distance(to: currentDate)
                            
                            if distance >= stepTime && timeToAnswer > 1.0 {
                                
                                if (currentStep < 4) {
                                    currentStep += 1
                                }
                                
                                switch timeToAnswer {
                                    case 2.0:
                                        timeToAnswer -= 1.0
                                        stepTime = 60.0
                                    case 3.0...4.0:
                                        timeToAnswer -= 1.0
                                        stepTime = 50.0
                                    default:
                                        timeToAnswer -= 2.0
                                        stepTime = 45.0
                                }
                                
                                self.playingTime = Date()
                                if interval < 8 {
                                    interval += 1
                                }
                            }
                            
                        }
                    }
                    .fullScreenCover(isPresented: $isGameOver) {
                        restartGame(note, clef)
                    } content: {
                        GameOverView(score: score, isGameOver: $isGameOver)
                    }
                    .padding(.top, 24)
                                
                VStack(spacing: 24) {
                    ProgressBar(progressWidth: $progressBarWidth)
                        .onReceive(progressBarTimer) { _ in
                            if !isGameOver && hasGameStarted {
                                let p = (300.0 * 0.001) / timeToAnswer
                                progressBarWidth = abs(progressBarWidth - p)
                            }
                        }
                    
                    KeyView(notePressed: $notePressed, keyOnColor: $keyOnColor)
                        .onChange(of: self.notePressed) { notePressed in
                            if (notePressed != "none") {
                                checkCorrectAnswer(notePressed: notePressed, note: note, clef: clef)
                            }
                        }
                }
                .padding()
                .padding(.top, 40)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    goToLevelsView()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("customBlack"))
                }
            }
            ToolbarItemGroup(placement: .principal) {
                HStack {
                    ForEach((0..<errors), id: \.self) { _ in
                        Circle()
                            .fill(Color(red: 184/255, green: 15/255, blue: 23/255))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Text(String(score))
                    .font(.title)
            }
        }
    }
}

private func playSound(_ resource : String) {
    if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound")
        }
    }
}

//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView()
//            .previewDevice("iPhone 12")
//            .previewInterfaceOrientation(.portrait)
//    }
//}
