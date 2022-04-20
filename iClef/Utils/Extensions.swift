//
//  Extensions.swift
//  iClef
//
//  Created by Andrea Brugaletta on 20/04/22.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
