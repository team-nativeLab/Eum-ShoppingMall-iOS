import SwiftUI

struct MarketingConsentInfoView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("마케팅 수신 동의 안내")
                        .font(EUMTypography.labelLarge)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("수신 목적, 채널, 대상 정보와 철회 방법에 대한 승인 문구가 제공되지 않았습니다.")
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("마케팅 정보 수신 동의는 선택 사항이며, 동의하지 않아도 회원가입할 수 있습니다.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
            bottomAction
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .accessibilityAddTraits(.isModal)
    }

    private var topBar: some View {
        ZStack {
            Text("마케팅 수신 동의")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onClose) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("마케팅 수신 동의 닫기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var bottomAction: some View {
        EUMButton(title: "회원가입으로 돌아가기", kind: .secondary, size: .large, action: onClose)
            .accessibilityIdentifier("signup-marketing-consent-back")
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(EUMColor.backgroundSwiftUI)
            .overlay(alignment: .top) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            }
    }
}
