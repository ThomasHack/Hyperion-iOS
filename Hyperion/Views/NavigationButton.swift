//
//  NavigationButton.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {

    var destination: Destination
    var imageName: String

    var body: some View {
        NavigationLink(destination: self.destination) {
            Image(systemName: imageName).imageScale(.large)
        }
    }
}
