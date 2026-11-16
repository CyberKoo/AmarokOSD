# Project Guidelines

## Platform and Architecture
- Develop the application with SwiftUI. Use AppKit only when a required macOS capability has no suitable SwiftUI equivalent.
- Follow the macOS deployment target configured in the Xcode project. Guard APIs introduced after that target, including APIs introduced in macOS 26.0, with availability checks and suitable fallback behavior.
- Use Swift 6.2 with strict concurrency for new code and refactoring. Prefer `async`/`await` over completion handlers.
- Use the Observation framework for observable state. Mark `@Observable` view models and UI state classes with `@MainActor`. Do not introduce `ObservableObject`, `@Published`, or `@StateObject` in new or refactored code.
- Keep view state local with `@State` and pass read-only values directly. Use `@Binding` only when a child view must mutate state owned by its parent.

## macOS User Interface and Interaction
- Choose scene types according to their behavior: `WindowGroup` for document or application windows, `Window` for single-instance utility windows, `Settings` for preferences, and `MenuBarExtra` for menu bar interfaces. Support the standard `Cmd+,` shortcut for preferences.
- Use `NavigationSplitView` for multi-column master-detail layouts, an inspector for trailing detail panes, and `Table` for multi-column sortable data.
- Expose primary actions in the macOS menu bar with `.commands { CommandGroup(...) }` and standard `.keyboardShortcut(...)` modifiers.
- Use standard macOS control sizes and `.formStyle(.grouped)` in settings and inspector views. Support pointer interactions with `.onHover` and `.contextMenu`, and manage focus with `@FocusState`.
- Use SF Symbols through `Image(systemName:)` and semantic system colors such as `Color.primary`, `.secondary`, and `.accentColor`. Support Light Mode, Dark Mode, and the system accent color.
- Prefer Apple's Liquid Glass design. Use native Liquid Glass APIs on supported macOS versions and the existing fallback behavior on earlier supported versions.
- Reuse the components and styles in the existing design system. Match its materials, colors, spacing, and interaction patterns. Do not create alternative styles for components that serve the same purpose.

## Code Organization and Style
- Keep modules, types, and files cohesive, and minimize coupling between unrelated responsibilities.
- Apply the Single Responsibility Principle. Define one primary type per file and keep unrelated implementations in separate files.
- Group files by feature rather than by technical layer. Place each file with the related implementation, and name directories and files according to their responsibilities. Do not place code in an unrelated directory or group.
- Keep `body` properties concise. Extract complex subviews into dedicated `View` structs instead of `@ViewBuilder` helper functions.
- Add a `#Preview` block at the bottom of every view file, using mock or sample data.

## Bug Fixes
- Correct the underlying cause of each bug. Do not suppress symptoms with special cases, workaround code, or additional abstraction over a flawed implementation.
- Treat internal APIs as application code rather than public library interfaces. Refactor implementations and all call sites directly when necessary. Do not add compatibility layers for downstream consumers because this application has none.

## Dependencies, Testing, and Verification
- Manage Swift dependencies exclusively with Swift Package Manager.
- Write unit tests with Swift Testing using `import Testing`, `@Test`, and `#expect`. Use XCTest only for XCUITest-based UI tests.
- Keep unit tests independent of screen resolution, display dimensions, scaling factors, actual window dimensions, and the runtime display configuration. Pass explicit dimensions to pure layout functions. Never read `NSScreen`, the current window's `frame`, or other runtime display state to determine unit-test inputs or assertions.
- Place tests that require real window or screen behavior in the UI test target. These tests must not assume that the local machine or CI environment has a particular hardware resolution.
- Build the macOS scheme with Xcode or `xcodebuild` before finishing a task. The build must complete without compiler errors or Swift 6 concurrency warnings.
