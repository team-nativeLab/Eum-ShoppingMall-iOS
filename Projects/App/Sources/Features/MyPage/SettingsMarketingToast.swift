import SwiftUI

struct SettingsMarketingToast: View {
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image("SettingsToastCheck")
                .resizable()
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)
            Text(message)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.toastSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .shadow(color: EUMColor.text1SwiftUI.opacity(0.08), radius: 16, x: 0, y: 4)
        .accessibilityElement(children: .combine)
    }
}
