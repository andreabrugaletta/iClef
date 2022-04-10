//
//  ClefView.swift
//  iClef
//
//  Created by Andrea Brugaletta on 10/04/22.
//

import SwiftUI

struct ClefView: View {
    
    @State var geometry : GeometryProxy?
    @State var clefName : ClefName

    var body: some View {
        let clef = Clef(name: clefName)
                
        if let geometry = geometry {
            Image(clef.assetName)
                .resizable()
                .scaledToFit()
                .frame(height: geometry.size.height * clef.frameHeight)
                .offset(x: geometry.frame(in: .local).origin.x + clef.xOffset,
                        y: geometry.size.height / clef.yOffset)
        } else {
            Text("geometry is nil")
        }
    }
}

struct ClefView_Previews: PreviewProvider {
    static var previews: some View {
        ClefView(geometry: nil, clefName: .treble)
    }
}
