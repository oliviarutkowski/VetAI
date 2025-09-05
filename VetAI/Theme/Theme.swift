#if canImport(SwiftUI)
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

struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    // New naming used by modern components
    static let l: CGFloat = 16
}

struct Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    // Radius used for card components
    static let card: CGFloat = 16
    // Radius used for primary buttons
    static let button: CGFloat = md
}

struct Shadow {
    static let radius: CGFloat = 2
    static let x: CGFloat = 0
    static let y: CGFloat = 2
    // Color token for card shadow
    static let card = Color.black.opacity(0.1)
}

enum Typography {
    static let title = Font.system(size: 34, weight: .bold, design: .rounded)
    static let section = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .regular, design: .rounded)
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
#endif
