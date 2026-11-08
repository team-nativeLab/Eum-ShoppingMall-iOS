import SwiftUI

struct LogoutConfirmationDialog: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("로그아웃하시겠습니까?")
                    .font(EUMTypography.heading3)
                    .tracking(-0.27)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("다시 로그인하면 이어서 이용할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
            }

            HStack(spacing: 8) {
                EUMButton(title: "취소", kind: .secondary, size: .medium, action: onCancel)
                EUMButton(title: "로그아웃", kind: .primary, size: .medium, action: onConfirm)
            }
        }
        .padding(24)
        .frame(width: 350)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .shadow(color: EUMColor.text1SwiftUI.opacity(0.16), radius: 32, x: 0, y: 12)
        .accessibilityElement(children: .contain)
    }
}
