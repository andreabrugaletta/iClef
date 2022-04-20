//
//  ProgressBar.swift
//  iClef
//
//  Created by Andrea Brugaletta on 20/04/22.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progressWidth : CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.gray)
                .frame(width: 300, height: 5)
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.green)
                .frame(width: progressWidth, height: 5)
        }
    }
}