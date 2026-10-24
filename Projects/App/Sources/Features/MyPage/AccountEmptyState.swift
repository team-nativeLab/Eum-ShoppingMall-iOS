import SwiftUI

struct AccountEmptyState: View {
    // Resolved Figma variables for these frames; older app screens use the existing palette.
    static let background = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    let title: String
    let message: String
    var actionTitle: String?
    var actionIdentifier = "account-empty-action"
    var onAction: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                Image("FavoritesEmpty")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .frame(width: 64, height: 64)
                    .background(.white, in: Circle())
                Spacer().frame(height: 20)
                Text(title)
                    .font(EUMTypography.heading3)
                    .tracking(-0.27)
                    .foregroundStyle(Color(red: 23 / 255, green: 23 / 255, blue: 23 / 255))
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 8)
                Text(message)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(Color(red: 74 / 255, green: 74 / 255, blue: 74 / 255))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .frame(maxWidth: 280)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer().frame(height: 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 64)
            .padding(.bottom, 32)
            if let actionTitle {
                Button(action: onAction) {
                    Text(actionTitle)
                        .font(.custom("NotoSansKR-Bold", size: 14))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(red: 20 / 255, green: 26 / 255, blue: 23 / 255),
                                    in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(actionIdentifier)
            }
        }
    }
}

/// Fixture selection is limited to debug builds; production always uses the normal data source.
enum AccountSampleData {
    static var isEmpty: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains("-ui-test-empty-account")
        #else
        false
        #endif
    }
}
