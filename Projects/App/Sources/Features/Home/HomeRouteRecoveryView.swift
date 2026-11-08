import SwiftUI

struct HomeRouteRecoveryView: View {
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("화면을 열 수 없어요.")
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
            EUMButton(title: "이전 화면으로", kind: .secondary, action: onBack)
                .frame(maxWidth: 180)
                .accessibilityIdentifier("route-recovery-back")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EUMColor.backgroundSwiftUI)
    }
}
