import SwiftUI

/// Header used by the newer Figma screens (A-43–A-57): leading 18 pt title and a bottom divider.
struct EUMLeadingTitleTopBar: View {
    let title: String
    let backAccessibilityLabel: String
    let backAccessibilityIdentifier: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image("ProductDetailBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 32, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(backAccessibilityLabel)
            .accessibilityIdentifier(backAccessibilityIdentifier)

            Text(title)
                .font(.custom(EUMFontName.semibold, size: 18))
                .lineLimit(1)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay(alignment: .bottom) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }
}
