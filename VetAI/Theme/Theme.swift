import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

enum Palette {
    static let primary = Color("PrimaryGreen")
    static let surface = Color("Surface")
    static let cyanDark = Color("CyanDark") // TODO: refine hex
    static let blueAccent = Color("BlueAccent") // TODO: refine hex
    static let surfaceAlt: Color = {
        #if canImport(UIKit)
        return Color(UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                let base = UIColor.systemBackground
                var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                base.getRed(&r, green: &g, blue: &b, alpha: &a)
                return UIColor(red: min(r + 0.12, 1),
                                green: min(g + 0.12, 1),
                                blue: min(b + 0.12, 1),
                                alpha: a)
            } else {
                return UIColor(white: 0.97, alpha: 1)
            }
        })
        #else
        return Color(white: 0.97)
        #endif
    }()
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
