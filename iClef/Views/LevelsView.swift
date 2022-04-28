//
//  LevelsView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 28/04/22.
//

import SwiftUI

struct LevelsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                ForEach((1...7), id: \.self) { n in
                    NavigationLink {
                        GameView(level: n)
                    } label: {
                        Text("Level \(n)")
                    }
                }
            }
            .padding(.top, -100)
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView()
    }
}
