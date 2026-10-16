import SwiftUI

struct DocumentColumn: View {
    let panel: PanelState

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            ScrollView {
                DocumentBody()
                    .padding(.top, 2)
                    .padding(.bottom, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.appBG)
    }

    // MARK: floating glass toolbar

    private var toolbar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 2) {
                IconButton(symbol: "sidebar.left",
                           label: "Toggle sidebar",
                           tint: panel.sidebarOpen ? Color(hex: 0x3a3c3e) : Palette.accent) {
                    panel.toggleSidebar()
                }
                IconButton(symbol: "chevron.backward", label: "Back", tint: Color(hex: 0x3a3c3e)) {}
            }
            .padding(4)
            .glassPill()

            Text("This is the book's title")
                .font(inter(16, .semibold))
                .foregroundStyle(Palette.ink)
                .lineLimit(1)

            Spacer(minLength: 8)

            HStack(spacing: 2) {
                IconButton(symbol: "pencil.tip", label: "Annotate", tint: Color(hex: 0x3a3c3e)) {}
                IconButton(symbol: "plus.square", label: "Add", tint: Color(hex: 0x3a3c3e)) {}
            }
            .padding(4)
            .glassPill()

            // ✦ AI button — present in the toolbar only while the panel is closed.
            // When opened it "lifts" into the GovernAI panel header (annotation #2).
            if !panel.governAIOpen {
                Button { panel.toggleGovernAI() } label: {
                    Image(systemName: "sparkles")
                        .font(.system(size: 22))
                        .foregroundStyle(Palette.ai)
                        .frame(width: 46, height: 46)
                }
                .buttonStyle(.plain)
                .glassPill(radius: 23)
                .accessibilityLabel("Open GovernAI")
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }
}

// MARK: - The "book" page

struct DocumentBody: View {
    private let resolutions: [(String, String, String)] = [
        ("Approval of updated Conflict of Interest Policy", "Legal & Compliance", "Pending Vote"),
        ("Executive compensation framework for FY2025", "HR Committee", "Under Review"),
        ("Adoption of AI Governance Charter", "Technology Committee", "Pending Vote"),
        ("Authorization of $50M share buyback program", "CFO", "Pending Vote"),
        ("Amendment to Board Charter — digital voting", "Company Secretary", "First Reading")
    ]

    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 0) {
                Text("GlobalTech Industries   |   Board of Directors — Governance & Risk Committee")
                    .font(inter(13))
                    .foregroundStyle(Palette.ink4)
                Rectangle().fill(Palette.lineSoft).frame(height: 1)
                    .padding(.top, 12).padding(.bottom, 30)

                sectionHeading("4. Audit Committee Report")
                paragraph("Internal audit completed 6 scheduled engagements in Q3 2024, resulting in 14 observations across three priority tiers. The external auditor has confirmed independence and no material weaknesses were identified in the financial reporting process.")

                subHeading("High Priority Findings")
                bullet("Access control gaps in legacy ERP system: Privileged user accounts not reviewed for 18 months. Remediation plan submitted by CIO, target close date: October 31, 2024.")
                bullet("Vendor due diligence gaps: 12 active vendors lack current third-party risk assessments. Procurement has initiated remediation; target close: November 30, 2024.")
                bullet("Expense policy exceptions in APAC region: Pattern of approvals bypassing standard controls. HR and Finance conducting joint review.")

                subHeading("Medium & Low Priority")
                paragraph("8 medium and 3 low priority observations were raised, all with accepted management responses and agreed remediation timelines. Full detail is available in the Internal Audit Summary Report (Attachment A).")

                rule()

                sectionHeading("5. Resolutions Pending Board Approval")
                paragraph("The following resolutions require board vote at the Q3 Extraordinary Meeting scheduled for October 15, 2024:")
                resolutionTable
                Text("Supporting materials for each resolution have been distributed via the secure board portal. Directors are requested to submit questions in advance to the Company Secretary no later than October 10, 2024.")
                    .font(inter(15).italic())
                    .foregroundStyle(Palette.ink2)
                    .padding(.top, 4)

                rule()

                sectionHeading("6. Committee Sign-Off")
                paragraph("The Governance & Risk Committee has reviewed the above items and recommends their advancement to the full Board for deliberation and vote.")

                Text("Confidential — For Board Use Only   |   Page 3")
                    .font(inter(12))
                    .foregroundStyle(Palette.ink4)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 30)
            }
            .padding(.horizontal, 56)
            .padding(.vertical, 46)
            .frame(maxWidth: 820, alignment: .leading)
            .background(Palette.surface)
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
            Spacer(minLength: 0)
        }
    }

    // MARK: text helpers

    private func sectionHeading(_ t: String) -> some View {
        Text(t).font(inter(26, .bold)).foregroundStyle(Palette.navy)
            .padding(.top, 30).padding(.bottom, 12)
    }
    private func subHeading(_ t: String) -> some View {
        Text(t).font(inter(18, .bold)).foregroundStyle(Palette.navy2)
            .padding(.top, 22).padding(.bottom, 8)
    }
    private func paragraph(_ t: String) -> some View {
        Text(t).font(inter(16)).foregroundStyle(Palette.bodyInk).lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 12)
    }
    private func bullet(_ t: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•").font(inter(16)).foregroundStyle(Palette.bodyInk)
            Text(t).font(inter(16)).foregroundStyle(Palette.bodyInk).lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, 6)
        .padding(.bottom, 9)
    }
    private func rule() -> some View {
        Rectangle().fill(Palette.line).frame(height: 1).padding(.vertical, 22)
    }

    // MARK: table

    // Column proportions (Resolution gets the most room, like the mock).
    private let colFractions: [CGFloat] = [0.52, 0.27, 0.21]

    private var resolutionTable: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let w = geo.size.width
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        tableCell("Resolution", width: w * colFractions[0], head: true)
                        tableCell("Proposed By", width: w * colFractions[1], head: true)
                        tableCell("Status", width: w * colFractions[2], head: true)
                    }
                    .background(Palette.tableHead)

                    ForEach(Array(resolutions.enumerated()), id: \.offset) { idx, row in
                        HStack(spacing: 0) {
                            tableCell(row.0, width: w * colFractions[0])
                            tableCell(row.1, width: w * colFractions[1])
                            tableCell(row.2, width: w * colFractions[2])
                        }
                        .background(idx % 2 == 1 ? Color(hex: 0xf7f8fa) : Color.white)
                    }
                }
                .overlay(Rectangle().strokeBorder(Palette.line, lineWidth: 1))
            }
            .frame(height: CGFloat(resolutions.count + 1) * 40)
        }
        .padding(.top, 10)
        .padding(.bottom, 16)
    }

    private func tableCell(_ t: String, width: CGFloat, head: Bool = false) -> some View {
        Text(t)
            .font(inter(15, head ? .bold : .regular))
            .foregroundStyle(head ? .white : Palette.bodyInk)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, 14)
            .frame(width: width, height: 40, alignment: .leading)
            .overlay { if !head { Rectangle().strokeBorder(Palette.line, lineWidth: 0.5) } }
    }
}
