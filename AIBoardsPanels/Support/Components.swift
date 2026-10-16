import SwiftUI

// MARK: - Liquid-Glass functional layer

/// Glass pill used for the floating toolbars (functional layer only, per HIG `liquid-glass.md`).
struct GlassPill: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    var radius: CGFloat = 22

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return content
            .background {
                if reduceTransparency {
                    shape.fill(Color.white.opacity(0.96))
                } else {
                    shape.fill(.ultraThinMaterial)
                }
            }
            .overlay {
                shape.strokeBorder(Color.white.opacity(0.6), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.10), radius: 9, y: 4)
            .clipShape(shape)
    }
}

extension View {
    func glassPill(radius: CGFloat = 22) -> some View { modifier(GlassPill(radius: radius)) }
}

// MARK: - Icon button (SF Symbols, labelled for accessibility)

struct IconButton: View {
    let symbol: String
    let label: String
    var size: CGFloat = 40
    var glyph: CGFloat = 20
    var tint: Color = Palette.ink2
    var filledBackground: Color? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: glyph, weight: .regular))
                .foregroundStyle(tint)
                .frame(width: size, height: size)
                .background {
                    if let bg = filledBackground {
                        Circle().fill(bg)
                    }
                }
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

// MARK: - Hairline divider

struct Hairline: View {
    var color: Color = Palette.line
    var body: some View { Rectangle().fill(color).frame(height: 1) }
}
