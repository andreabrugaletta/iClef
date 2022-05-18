//
//  GameOverView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 14/05/22.
//

import SwiftUI

struct GameOverView: View {
    @State var score : Int = 0
    @Binding var isGameOver : Bool
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("GAME OVER!")
                Text("Score: \(score)")
                Text("Highest score: \(userSettings.highestScore)")
                HStack(spacing: 20) {
                    Button {
                        isGameOver = false
                    } label: {
                        Text("Retry")
                    }
                }
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(isGameOver: .constant(true))
    }
}
