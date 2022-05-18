//
//  LevelsView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 28/04/22.
//

import SwiftUI

struct LevelsView: View {
    
    @ViewBuilder func createMenuItem(difficulty : String, description: String) -> some View {
        VStack(spacing: 4) {
            Text(difficulty)
                .font(.system(size: 22))
            Text(description)
                .fontWeight(.light)
                .foregroundColor(.init(red: 130/255, green: 130/255, blue: 130/255))
        }
        .padding(.horizontal, 70)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("cream")
                    .ignoresSafeArea()
                VStack(spacing: 50) {
                    ForEach((1...4), id: \.self) { n in
                        NavigationLink {
                            GameView(level: n)
                        } label: {
                            switch n {
                                case 1:
                                    createMenuItem(difficulty: "Beginner", description: "Practice treble clef notes.")
                                case 2:
                                    createMenuItem(difficulty: "Intermediate", description: "Practice treble and bass clef notes.")
                                case 3:
                                    createMenuItem(difficulty: "Advanced", description: "Practice the four most used clefs: treble, bass, alto and tenor.")
                                case 4:
                                    createMenuItem(difficulty: "Expert", description: "The last level: practice reading notes in all seven clefs.")
                                default:
                                    EmptyView()
                            }
                        }
                        .foregroundColor(Color("customBlack"))
                    }
                }
                .padding(.top, -100)
            }
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView()
    }
}
