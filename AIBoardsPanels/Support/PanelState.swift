import SwiftUI
import Observation

/// Drives all panel behavior. Two independent flags; opening GovernAI
/// auto-collapses the sidebar (Figma annotation #1). The sidebar can then be
/// re-opened so both panes coexist (the "both open" frame).
@Observable
final class PanelState {
    var sidebarOpen: Bool = true
    var governAIOpen: Bool = false

    func toggleSidebar() {
        sidebarOpen.toggle()
    }

    func toggleGovernAI() {
        governAIOpen.toggle()
        if governAIOpen { sidebarOpen = false }
    }

    func apply(sidebar: Bool, ai: Bool) {
        sidebarOpen = sidebar
        governAIOpen = ai
    }

    /// Which quick-state preset is currently active (for the helper bar).
    var presetKey: String {
        switch (sidebarOpen, governAIOpen) {
        case (true, true):   return "both"
        case (false, true):  return "ai"
        case (true, false):  return "sidebar"
        default:             return "none"
        }
    }
}
