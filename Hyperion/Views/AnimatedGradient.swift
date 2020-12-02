//
//  AnimatedGradient.swift
//  Hyperion
//
//  Created by Hack, Thomas on 13.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct AnimatedGradient: View {

    @State var gradient = [
        Color.red, // Color(red: 85/255, green: 155/255, blue: 211/255),
        Color.blue, // Color(red: 24/255, green: 132/255, blue: 187/255),
        Color.green, // Color(red: 49/255, green: 149/255, blue: 184/255),
        Color.yellow //Color(red: 45/255, green: 153/255, blue: 158/255)
    ]
    @State var startPoint = UnitPoint(x: 0, y: 0)
    @State var endPoint = UnitPoint(x: 0, y: 2)

    var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: self.startPoint, endPoint: self.endPoint))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                withAnimation (.easeInOut(duration: 3)){
                    self.startPoint = UnitPoint(x: 1, y: -1)
                    self.endPoint = UnitPoint(x: 0, y: 1)
                }
        }
    }
}
