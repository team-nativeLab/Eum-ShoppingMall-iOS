import SwiftUI

struct EUMButton: View {
    enum Kind: Equatable {
        case primary
        case secondary
        case ghost
        case danger
    }

    enum Size: Equatable {
        case large
        case medium
        case small

        var height: CGFloat {
            switch self {
            case .large: 56
            case .medium: 48
            case .small: 36
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .large: 20
            case .medium: 16
            case .small: 12
            }
        }

        var font: Font {
            self == .large ? EUMTypography.labelLarge : EUMTypography.labelMedium
        }

        var tracking: CGFloat { self == .large ? -0.08 : -0.07 }
    }

    let title: String
    var kind: Kind = .primary
    var size: Size = .medium
    var trailingSymbol: String?
    var action: () -> Void

    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var isFocused: Bool

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                if let trailingSymbol {
                    Image(systemName: trailingSymbol)
                        .font(.system(size: size == .large ? 20 : size == .medium ? 18 : 16))
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(EUMButtonPressStyle(kind: kind, size: size, isEnabled: isEnabled, isFocused: isFocused))
        .focused($isFocused)
        .accessibilityLabel(title)
    }
}

private struct EUMButtonPressStyle: ButtonStyle {
    let kind: EUMButton.Kind
    let size: EUMButton.Size
    let isEnabled: Bool
    let isFocused: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .tracking(size.tracking)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background {
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .fill(color(isPressed: configuration.isPressed))
            }
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 2 : borderWidth)
            }
            .contentShape(RoundedRectangle(cornerRadius: EUMRadius.button))
    }

    private var foregroundColor: Color {
        guard isEnabled else { return EUMColor.textDisabledSwiftUI }
        return kind == .primary || kind == .danger ? EUMColor.inverseSwiftUI : EUMColor.text1SwiftUI
    }

    private var borderWidth: CGFloat { kind == .secondary ? 1 : 0 }

    private var borderColor: Color {
        guard isEnabled else { return Color(uiColor: EUMColor.line) }
        return isFocused ? EUMColor.text1SwiftUI : (kind == .secondary ? Color(uiColor: EUMColor.lineStrong) : .clear)
    }

    private func color(isPressed: Bool) -> Color {
        guard isEnabled else {
            return kind == .primary ? EUMColor.surfaceDisabledSwiftUI : EUMColor.backgroundSwiftUI
        }
        guard isPressed else {
            switch kind {
            case .primary: return EUMColor.text1SwiftUI
            case .secondary: return EUMColor.backgroundSwiftUI
            case .ghost: return .clear
            case .danger: return EUMColor.dangerSwiftUI
            }
        }
        switch kind {
        case .primary: return EUMColor.pressedDarkSwiftUI
        case .secondary, .ghost: return EUMColor.surfaceSwiftUI
        case .danger: return EUMColor.dangerSwiftUI
        }
    }
}

struct EUMButtonPreview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EUMButton(title: "기본 버튼") {}
            EUMButton(title: "보조 버튼", kind: .secondary) {}
            EUMButton(title: "위험 동작", kind: .danger) {}
            EUMButton(title: "비활성 버튼") {}.disabled(true)
        }
        .padding()
    }
}
