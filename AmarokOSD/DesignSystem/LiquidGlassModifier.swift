import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    let cornerRadius: Double
    let tint: Color?
    let isInteractive: Bool
    let fallback: AnyShapeStyle
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(AppTheme.cardBackground, in: shape)
                .background(tint ?? .clear, in: shape)
        } else if #available(macOS 26.0, *) {
            content
                .glassEffect(glass, in: shape)
        } else {
            content
                .background(fallbackBackground, in: shape)
        }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    private var fallbackBackground: AnyShapeStyle {
        tint.map { AnyShapeStyle($0) } ?? fallback
    }

    @available(macOS 26.0, *)
    private var glass: Glass {
        var glass = Glass.regular
        if let tint {
            glass = glass.tint(tint)
        }
        return glass.interactive(isInteractive)
    }
}

extension View {
    func liquidGlass(
        cornerRadius: Double,
        tint: Color? = nil,
        interactive: Bool = false,
        fallback: AnyShapeStyle = AnyShapeStyle(.regularMaterial)
    ) -> some View {
        modifier(
            LiquidGlassModifier(
                cornerRadius: cornerRadius,
                tint: tint,
                isInteractive: interactive,
                fallback: fallback
            )
        )
    }

    @ViewBuilder
    func liquidGlassButtonStyle(prominent: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            if prominent {
                buttonStyle(.glassProminent)
            } else {
                buttonStyle(.glass)
            }
        } else {
            if prominent {
                buttonStyle(.borderedProminent)
            } else {
                buttonStyle(.bordered)
            }
        }
    }
}
