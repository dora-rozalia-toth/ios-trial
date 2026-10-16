import SwiftUI
import CoreText
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Color tokens (from Figma "Govern AI panel stater - latest version")

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

enum Palette {
    static let ink      = Color(hex: 0x232429)
    static let ink2     = Color(hex: 0x575a67)
    static let ink3     = Color(hex: 0x8f9193)
    static let ink4     = Color(hex: 0xc6c6c9)

    static let navy     = Color(hex: 0x2e4372)   // document section headings
    static let navy2    = Color(hex: 0x455d82)   // sub headings
    static let tableHead = Color(hex: 0x22304c)

    static let accent   = Color(hex: 0x0040d5)   // system blue
    static let danger   = Color(hex: 0x87222f)
    static let ai       = Color(hex: 0x6b47d6)   // GovernAI purple
    static let aiTint   = Color(hex: 0xece7fb)

    static let appBG    = Color(hex: 0xeceef1)
    static let surface  = Color.white
    static let panelBG  = Color(hex: 0xf6f7f9)
    static let selection = Color(hex: 0xe6edfb)
    static let line     = Color(hex: 0xe7e8ec)
    static let lineSoft = Color(hex: 0xeef0f3)

    static let bodyInk  = Color(hex: 0x2b2d33)
}

// MARK: - Inter font (bundled TTFs, registered at runtime; falls back to system)

enum AppFont {
    static func register() {
        for name in ["Inter-Regular", "Inter-Medium", "Inter-SemiBold", "Inter-Bold"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

/// Inter at a given size/weight, with a graceful fall back to the system font.
func inter(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
    let psName: String
    switch weight {
    case .bold, .heavy, .black: psName = "Inter-Bold"
    case .semibold:             psName = "Inter-SemiBold"
    case .medium:               psName = "Inter-Medium"
    default:                    psName = "Inter-Regular"
    }
    #if canImport(UIKit)
    if UIFont(name: psName, size: size) != nil {
        return .custom(psName, size: size)
    }
    #endif
    return .system(size: size, weight: weight)
}
