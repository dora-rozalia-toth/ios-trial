# AI Boards — iPad Panel-Behavior Prototype (SwiftUI)

A real iPad app (SwiftUI, iOS 17+, landscape) prototyping a book/document viewer
whose right-hand **GovernAI** panel behaves like the info/inspector panel in Apple
Preview on iPad: it slides in from the right and **pushes / resizes** the document
instead of covering it.

```
open "AIBoardsPanels.xcodeproj"
# choose an iPad simulator (e.g. iPad Pro 13-inch), then Run (⌘R)
```

## The behavior

- **Tap the ✦ GovernAI button** (top-right): the panel springs in from the right and
  pushes the document narrower; the ✦ button turns its highlighted purple and
  "lifts" into the panel header; the left sidebar **auto-collapses**.
- **Tap the sidebar toggle while GovernAI is open**: the sidebar comes back and
  both panels coexist.
- **Tap the active ✦ again**: the panel slides out and the ✦ returns to the toolbar.
- **Sidebar toggle on its own**: plain collapse / expand.
- A dark **quick-state bar** at the bottom (Sidebar · GovernAI · Both · Reading) is a
  stakeholder convenience — not part of the real UI.
- Honors Reduce Motion.

See [`SPEC.md`](./SPEC.md) for the full behavior spec and the Figma source.

## Notes

- Built with the Xcode 16+ synchronized-folder project format; every file under
  `AIBoardsPanels/` (including the Inter TTFs in `Resources/Fonts/`) is picked up
  automatically.
- Inter is registered at runtime, so no `Info.plist` font setup is needed. If the
  fonts are ever missing, the app falls back to the system font.
- Fallback if the project file ever won't open: create a new Xcode *App* project
  (SwiftUI, iPad), delete its template files, and drag the `AIBoardsPanels/` folder
  in as a folder reference — the same sources will build.

Inter is licensed under the SIL Open Font License (see
`AIBoardsPanels/Resources/Fonts/Inter-OFL-LICENSE.txt`).
