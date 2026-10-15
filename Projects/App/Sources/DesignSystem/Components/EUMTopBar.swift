import SwiftUI

struct EUMTopBar: View {
    var title: String? = nil
    var onMenuTap: () -> Void
    var onNotificationTap: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Button(action: onMenuTap) {
                Image("TopBarMenu")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("전체 메뉴")

            if let title {
                Text(title)
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                    .accessibilityAddTraits(.isHeader)
            }

            Spacer()

            Button(action: onNotificationTap) {
                Image("TopBarBell")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("알림")
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }
}
