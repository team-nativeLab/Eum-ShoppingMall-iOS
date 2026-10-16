import SwiftUI

struct EUMBackTopBar<TrailingContent: View>: View {
    let title: String
    let backAccessibilityLabel: String
    let contentSpacing: CGFloat?
    let onBack: () -> Void

    private let trailingContent: TrailingContent

    init(
        title: String,
        backAccessibilityLabel: String,
        contentSpacing: CGFloat? = nil,
        onBack: @escaping () -> Void,
        @ViewBuilder trailingContent: () -> TrailingContent
    ) {
        self.title = title
        self.backAccessibilityLabel = backAccessibilityLabel
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
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(backAccessibilityLabel)

                Spacer()
                trailingContent
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }
}
