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
    var date: Date

    var fontSize: CGFloat {
        switch family {
        case .systemSmall:
            return 12
        case .systemMedium, .systemLarge:
            return 14
        case .systemExtraLarge:
            return 14
        @unknown default:
            return 12
        }
    }

    var topPadding: CGFloat {
        switch family {
        case .systemSmall:
            return 10
        case .systemMedium:
            return 16
        case .systemLarge:
            return 16
        case .systemExtraLarge:
            return 10
        @unknown default:
            return 8
        }
    }

    var bottomPadding: CGFloat {
        switch family {
        case .systemSmall:
            return 8
        case .systemMedium:
            return 16
        case .systemLarge:
            return 8
        case .systemExtraLarge:
            return 6
        @unknown default:
            return 8
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold, design: .default))
                .foregroundColor(Color(UIColor.label))
            Spacer()
            if family != .systemSmall {
                LastUpdated(date: date)
            }
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding([.leading, .trailing], 16)
        .frame(maxWidth: .infinity)
    }
}

struct WidgetHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WidgetHeaderView(title: "Hue Sync", date: Date())
            Spacer()
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
