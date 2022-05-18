//
//  UserSettings.swift
//  iClef
//
//  Created by Andrea Brugaletta on 15/05/22.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var highestScore: Int {
        didSet {
            UserDefaults.standard.set(highestScore, forKey: "highestScore")
        }
    }
    
    init() {
        self.highestScore = UserDefaults.standard.object(forKey: "highestScore") as? Int ?? 0
    }
}
