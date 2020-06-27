//
//  Settings.swift
//  Hyperion
//
//  Created by Hack, Thomas on 27.06.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(text: "Host")
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            }
            .navigationBarTitle(Text("Settings"), displayMode: .large)
            .background(Color(.secondarySystemBackground))
            .edgesIgnoringSafeArea(.all)
            .padding([.top], 10)
            .navigationBarItems(
                trailing:
                    HStack(spacing: 16) {
                        Button(action: {  }) {
                            Text("Done")
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
