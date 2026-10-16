import SwiftUI

struct OutlineRow: Identifiable {
    let id = UUID()
    let title: String
    let level: Int        // 0...3 indentation
    let isLeaf: Bool
    var expanded: Bool = false
}

struct ContentSidebar: View {
    let panel: PanelState
    @State private var selectedID: UUID?
    @State private var rows: [OutlineRow] = ContentSidebar.defaultRows
    @State private var segment = 0   // 0 Structure, 1 Thumbnails

    var body: some View {
        VStack(spacing: 0) {
            // Tool row + collapse control
            HStack {
                HStack(spacing: 2) {
                    toolIcon("list.bullet", "Outline", active: true)
                    toolIcon("magnifyingglass", "Search")
                    toolIcon("square.and.arrow.up", "Share")
                    toolIcon("pencil.tip", "Annotate")
                    toolIcon("bookmark", "Bookmark")
                }
                .padding(3)
                .glassPill()
                Spacer()
                IconButton(symbol: "sidebar.left", label: "Hide sidebar", tint: Palette.ink2) {
                    panel.toggleSidebar()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 10)

            // Title + segmented control
            VStack(alignment: .leading, spacing: 10) {
                Text("Content").font(inter(16, .semibold)).foregroundStyle(Palette.ink)
                HStack(spacing: 22) {
                    segmentButton("Structure", 0)
                    segmentButton("Thumbnails", 1)
                }
                .overlay(alignment: .bottom) { Hairline() }
            }
            .padding(.horizontal, 18)

            // Outline
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 2) {
                    ForEach($rows) { $row in
                        outlineRowView($row)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Palette.surface)
        .overlay(alignment: .trailing) { Hairline().frame(width: 1) }
        .onAppear { if selectedID == nil { selectedID = rows.first(where: { $0.title.hasPrefix("Globaltech") })?.id } }
    }

    // MARK: pieces

    private func toolIcon(_ symbol: String, _ label: String, active: Bool = false) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 18))
            .foregroundStyle(active ? Palette.accent : Palette.ink2)
            .frame(width: 36, height: 36)
            .background { if active { Circle().fill(Color.white).shadow(color: .black.opacity(0.12), radius: 2, y: 1) } }
            .accessibilityLabel(label)
    }

    private func segmentButton(_ title: String, _ index: Int) -> some View {
        Button { segment = index } label: {
            Text(title)
                .font(inter(13, .semibold))
                .foregroundStyle(segment == index ? Palette.ink : Palette.ink3)
                .padding(.bottom, 10)
                .overlay(alignment: .bottom) {
                    if segment == index {
                        Rectangle().fill(Palette.accent).frame(height: 2)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private func outlineRowView(_ row: Binding<OutlineRow>) -> some View {
        let isSelected = selectedID == row.wrappedValue.id
        return Button {
            if row.wrappedValue.isLeaf { selectedID = row.wrappedValue.id }
            else { row.wrappedValue.expanded.toggle() }
        } label: {
            HStack(spacing: 8) {
                if row.wrappedValue.isLeaf {
                    Image(systemName: "doc.text")
                        .font(.system(size: 15))
                        .foregroundStyle(isSelected ? Palette.accent : Palette.ink3)
                }
                Text(row.wrappedValue.title)
                    .font(inter(14, (row.wrappedValue.level == 0 || isSelected) ? .semibold : .regular))
                    .foregroundStyle(Palette.ink)
                    .lineLimit(row.wrappedValue.isLeaf ? 2 : 1)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 4)
                if !row.wrappedValue.isLeaf {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Palette.ink3)
                        .rotationEffect(.degrees(row.wrappedValue.expanded ? 90 : 0))
                }
            }
            .padding(.vertical, 9)
            .padding(.trailing, 10)
            .padding(.leading, CGFloat(10 + row.wrappedValue.level * 16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? Palette.selection : Color.clear)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: data

    static let defaultRows: [OutlineRow] = [
        .init(title: "Agenda", level: 0, isLeaf: false),
        .init(title: "1. Review of Key Financial Metrics", level: 0, isLeaf: false, expanded: true),
        .init(title: "Summary of the financial and auditdirector", level: 1, isLeaf: true),
        .init(title: "Proposals introduced in the very beginning and re…", level: 1, isLeaf: true),
        .init(title: "1.1. Revenue", level: 0, isLeaf: false),
        .init(title: "1.2. Expenses", level: 0, isLeaf: false, expanded: true),
        .init(title: "Secret ingredients", level: 1, isLeaf: true),
        .init(title: "1.2.1. What does the future holds?", level: 1, isLeaf: false, expanded: true),
        .init(title: "1.2.1.1. The unforeseen expen…", level: 2, isLeaf: false, expanded: true),
        .init(title: "Globaltech governance q3 2024", level: 3, isLeaf: true),
        .init(title: "Table of contents", level: 3, isLeaf: true),
        .init(title: "Profit Margin Details And Other Interesti…", level: 3, isLeaf: true),
        .init(title: "1.2.2. Next steps", level: 1, isLeaf: false),
        .init(title: "1.2.3. Conclusions about the above m…", level: 1, isLeaf: false),
        .init(title: "1.3. Profit Margins", level: 0, isLeaf: false)
    ]
}
