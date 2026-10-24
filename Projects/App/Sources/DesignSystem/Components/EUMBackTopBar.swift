import SwiftUI

struct EUMBackTopBar<TrailingContent: View>: View {
    let title: String
    let backAccessibilityLabel: String
    let backAccessibilityIdentifier: String?
    let contentSpacing: CGFloat?
    let onBack: () -> Void

    private let trailingContent: TrailingContent

    init(
        title: String,
        backAccessibilityLabel: String,
        backAccessibilityIdentifier: String? = nil,
        contentSpacing: CGFloat? = nil,
        onBack: @escaping () -> Void,
        @ViewBuilder trailingContent: () -> TrailingContent
    ) {
        self.title = title
        self.backAccessibilityLabel = backAccessibilityLabel
        self.backAccessibilityIdentifier = backAccessibilityIdentifier
        self.contentSpacing = contentSpacing
        self.onBack = onBack
        self.trailingContent = trailingContent()
    }

    var body: some View {
        ZStack {
            Text(title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: contentSpacing) {
                backButton

                Spacer()
                trailingContent
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var backButton: some View {
        Button(action: onBack) {
            Image("ProductDetailBack")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(backAccessibilityLabel)
        .modifier(OptionalAccessibilityIdentifier(identifier: backAccessibilityIdentifier))
    }
}

private struct OptionalAccessibilityIdentifier: ViewModifier {
    let identifier: String?

    @ViewBuilder
    func body(content: Content) -> some View {
        if let identifier {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
}
