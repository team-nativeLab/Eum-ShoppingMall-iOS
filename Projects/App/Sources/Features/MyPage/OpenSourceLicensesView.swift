import SwiftUI

struct OpenSourceLicensesView: View {
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            VStack(alignment: .leading, spacing: 12) {
                Text("오픈소스 라이선스")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("현재 앱 타깃에 등록된 외부 오픈소스 패키지가 없습니다.")
                    .font(EUMTypography.bodyMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(20)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("오픈소스 라이선스")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("뒤로 가기")
                .accessibilityIdentifier("open-source-licenses-back")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }
}
