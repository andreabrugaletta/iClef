//
//  GameOverView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 14/05/22.
//

import SwiftUI

struct GameOverView: View {
    @State var score : Int = 0
    @State var animatedScore : Int = 0
    @Binding var isGameOver : Bool
    @ObservedObject var userSettings = UserSettings()
    @State var bestScore = UserSettings().highestScore
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("cream")
                    .ignoresSafeArea()
                VStack(spacing: 8) {
                    Text("Your score")
                        .font(.system(size: 24))
                        .padding(.top, 48)
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .frame(width: 180, height: 44, alignment: .center)
                        .cornerRadius(25)
                        .modifier(AnimatingNumberOverlay(number: CGFloat(animatedScore)))
                        .onAppear {
                            withAnimation(Animation.easeIn(duration: 1.0)) {
                                animatedScore = score
                            }
                            
                        }
                        
                    Text("Best score")
                        .font(.system(size: 24))
                        .padding(.top, 8)
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .frame(width: 180, height: 44, alignment: .center)
                            .cornerRadius(25)
                            .modifier(AnimatingNumberOverlay(number: CGFloat(bestScore)))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(850)) {
                                    if score > userSettings.highestScore {
                                        userSettings.highestScore = score
                                        withAnimation(Animation.easeIn(duration: 1.0)) {
                                            bestScore = score
                                        }
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 180)
                    Button {
                        isGameOver = false
                    } label: {
                        Image("retry")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("customBlack"))
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

struct AnimatingNumberOverlay: AnimatableModifier {
    var number: CGFloat
    var animatableData: CGFloat {
        get {
            number
        }
        set {
            number = newValue
        }
    }
    func body(content: Content) -> some View {
        return content.overlay(Text("\(Int(number))").font(.system(size: 24)))
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(isGameOver: .constant(true))
    }
}
