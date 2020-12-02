//
//  ColorSlider.swift
//  Hyperion
//
//  Created by Hack, Thomas on 14.08.20.
//  Copyright © 2020 Hack, Thomas. All rights reserved.
//
import ComposableArchitecture
import SwiftUI

struct ColorControl: View {
    @Binding var color: Color
    
    @State var hue: CGFloat = 0
    @State var saturation: CGFloat = 1.0
    @State var brightness: CGFloat = 1.0

    var body: some View {
        VStack(alignment: .center, spacing: 16) {

            let hueColors = stride(from: 0, to: 1, by: 0.001).map { Color(hue: $0, saturation: Double($saturation.wrappedValue), brightness: Double($brightness.wrappedValue)) }
            let saturationColors = [Color.white, Color(hue: Double($hue.wrappedValue), saturation: Double($saturation.wrappedValue), brightness: Double($brightness.wrappedValue))]
            let brightnessColors = [Color.black, Color(hue: Double($hue.wrappedValue), saturation: Double($saturation.wrappedValue), brightness: Double($brightness.wrappedValue))]

            ZStack {
                Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0))
                    .cornerRadius(10)

                VStack {
                    Spacer()

                    HueSlider(value: $hue, hue: $hue, saturation: $saturation, brightness: $brightness, colors: hueColors)
                    HueSlider(value: $saturation, hue: $hue, saturation: $saturation, brightness: $brightness, colors: saturationColors)
                    HueSlider(value: $brightness, hue: $hue, saturation: $saturation, brightness: $brightness, colors: brightnessColors)
                }
                .padding(4)
            }
            .frame(height: 250)
        }
        .onChange(of: hue, perform: { value in
            color = Color(hue: Double(value), saturation: Double(saturation), brightness: Double(brightness))
        })
        .onChange(of: saturation, perform: { value in
            color = Color(hue: Double(hue), saturation: Double(value), brightness: Double(brightness))
        })
        .onChange(of: brightness, perform: { value in
            color = Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(value))
        })
    }
}

struct ColorControl_Previews: PreviewProvider {
    struct BindingTestHolder: View {
        @State var color: Color = .red
        @State var hue: CGFloat = 0
        @State var saturation: CGFloat = 0
        @State var brightness: CGFloat = 0

        var body: some View {
            ColorControl(color: $color)
        }
    }

    static var previews: some View {
        BindingTestHolder()
    }
}
