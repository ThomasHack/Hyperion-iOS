//
//  InstanceEditView.swift
//  Hyperion
//
//  Created by Hack, Thomas on 17.06.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import ComposableArchitecture
import HyperionApi
import SwiftUI

struct InstanceEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let store: Store<InstanceEdit.State, InstanceEdit.Action>

    private let columns = [
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50))
    ]

    private let iconNames = [
        "ambilight",
        "hdr-tone-mapping",
        "blackborder",
        "hue-bulb",
        "hue-lightstrip",
        "hue-playbars",
        "smoothing",
        "v4l-hardware"
    ]

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Instance Name")
                            .font(.system(size: 16, weight: .bold, design: .default))

                        TextField(viewStore.instance.friendlyName,
                                  text: viewStore.binding(
                                    get: { $0.instanceName },
                                    send: InstanceEdit.Action.instanceNameChanged
                                  )
                            )
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 24)

                    VStack(alignment: .leading) {
                        Text("Icon")
                            .font(.system(size: 16, weight: .bold, design: .default))

                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(iconNames, id: \.self) { icon in
                                VStack {
                                    Button {
                                        viewStore.send(InstanceEdit.Action.iconNameChanged(icon))
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        let selected = viewStore.state.iconName == icon
                                        Image(icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .clipped()
                                            .background(Color(selected
                                                              ? .secondarySystemBackground
                                                              : .systemBackground)
                                            )
                                            .cornerRadius(5)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.bottom, 24)

                    Spacer()
                }
                .navigationBarTitle("Settings")
                .padding()
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct IconSelection_Previews: PreviewProvider {
    static var previews: some View {
        InstanceEditView(
            store: Main.previewStoreInstanceEdit
        )
    }
}
