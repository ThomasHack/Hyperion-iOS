//
//  WidgetHeaderView.swift
//  ControlWidgetExtension
//
//  Created by Hack, Thomas on 17.02.21.
//  Copyright © 2021 Hack, Thomas. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetHeaderView: View {
    @Environment(\.widgetFamily) var family

    var title: String

    var fontSize: CGFloat {
        switch family {
        case .systemSmall:
            return 12
        case .systemMedium, .systemLarge:
            return 14
        @unknown default:
            return 12
        }
    }

    var spacing: CGFloat {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium, .systemLarge:
            return 12
        @unknown default:
            return 8
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold, design: .default))
                .foregroundColor(.white)
            Spacer()
        }
        .padding([.top, .bottom], spacing)
        .padding([.leading, .trailing], 16)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
}

struct WidgetHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetHeaderView(title: "Hue Sync")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
