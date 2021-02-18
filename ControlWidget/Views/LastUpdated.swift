//
//  LastUpdated.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit

struct LastUpdated: View {

    let date: Date

    var lastUpdated: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    var body: some View {
        HStack {
            Spacer()
            Text("Last updated \(lastUpdated)")
                .font(.system(size: 8, weight: .regular))
                .foregroundColor(Color(UIColor.secondaryLabel))
        }
        .padding(.trailing, 16)
    }
}

struct LastUpdated_Previews: PreviewProvider {
    static var previews: some View {
        LastUpdated(date: Date())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
