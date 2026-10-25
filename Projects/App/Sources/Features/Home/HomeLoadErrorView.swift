import SwiftUI

struct HomeLoadErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("홈 정보를 불러오지 못했어요.")
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
            EUMButton(title: "다시 시도", kind: .secondary, action: onRetry)
                .frame(maxWidth: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
