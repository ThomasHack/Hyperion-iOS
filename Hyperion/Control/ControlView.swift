//
//  ControlView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 02.07.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ControlView: View {
    let store: Store<Control.ControlFeatureState, Control.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(text: "Color")
                    VStack(spacing: 16) {

                        Button(action: {
                            viewStore.send(.clearButtonTapped)
                        }) {
                            HStack {
                                    Image(systemName: "clear.fill")
                                        .font(.body)
                                    Text("Clear")
                                        .fontWeight(.semibold)
                                        .font(.body)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            .padding([.top, .bottom], 12)
                                .foregroundColor(.white)
                                .background(Color(UIColor.black))
                                .cornerRadius(40)
                        }
                        Spacer()
                    }
                    .cornerRadius(15)

                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
                .padding([.top], 10)
                .navigationBarTitle(Text("Control"), displayMode: .automatic)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 24) {
                        }
                )
            }
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(store: Main.previewStoreControl)
    }
}
