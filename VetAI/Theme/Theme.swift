import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

enum Palette {
    static let primary: Color = {
        #if canImport(UIKit)
        if let uiColor = UIColor(named: "PrimaryGreen") {
            return Color(uiColor)
        }
        #endif
        return Color(hex: "#329E7B")
    }()
    static let surface = Color.white
    static let cyanDark = Color("CyanDark") // TODO: refine hex
    static let blueAccent = Color("BlueAccent") // TODO: refine hex
    static let surfaceAlt = Color(light: .init(white: 0.97), dark: .init(white: 0.12))
}

enum Typography {
    static let headline = Font.system(size: 34, weight: .bold, design: .rounded)
    static let section = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let button = Font.system(size: 18, weight: .semibold, design: .rounded)
}

extension Color {
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        self = light
        #endif
    }
}
