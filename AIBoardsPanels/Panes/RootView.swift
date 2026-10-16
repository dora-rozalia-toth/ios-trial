import SwiftUI

struct RootView: View {
    @State private var panel = PanelState()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var anim: Animation {
        reduceMotion
            ? .easeInOut(duration: 0.22)
            : .spring(response: 0.44, dampingFraction: 0.86)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Palette.appBG.ignoresSafeArea()

            // Three-pane split that PUSHES/resizes the document (split-views.md).
            HStack(spacing: 0) {
                if panel.sidebarOpen {
                    ContentSidebar(panel: panel)
                        .frame(width: 320)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }

                DocumentColumn(panel: panel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if panel.governAIOpen {
                    GovernAIPanel(panel: panel)
                        .frame(width: 400)
                        .transition(.move(edge: .trailing))
                        .zIndex(1)
                }
            }
            .animation(anim, value: panel.sidebarOpen)
            .animation(anim, value: panel.governAIOpen)

            HelperBar(panel: panel, anim: anim)
                .padding(.bottom, 12)
        }
    }
}

// MARK: - Stakeholder quick-state bar (not part of the mock)

struct HelperBar: View {
    let panel: PanelState
    let anim: Animation

    private let states: [(key: String, label: String, sidebar: Bool, ai: Bool)] = [
        ("sidebar", "Sidebar", true, false),
        ("ai", "GovernAI", false, true),
        ("both", "Both", true, true),
        ("none", "Reading", false, false)
    ]

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 1) {
                Text("AI Boards · panel behavior").font(inter(13, .bold)).foregroundStyle(.white)
                Text("Tap ✦ GovernAI, the sidebar toggle, or a quick state →")
                    .font(inter(12)).foregroundStyle(.white.opacity(0.72))
            }
            HStack(spacing: 6) {
                ForEach(states, id: \.key) { s in
                    let on = panel.presetKey == s.key
                    Button {
                        withAnimation(anim) { panel.apply(sidebar: s.sidebar, ai: s.ai) }
                    } label: {
                        Text(s.label)
                            .font(inter(12, .semibold))
                            .foregroundStyle(on ? Color(hex: 0x1c1e26) : .white)
                            .padding(.horizontal, 12).padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(on ? Color.white : Color.white.opacity(0.14))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 18).padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(hex: 0x1c1e26).opacity(0.86))
        )
        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
    }
}
