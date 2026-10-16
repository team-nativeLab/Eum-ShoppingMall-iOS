import SwiftUI

struct PrivacyConsentView: View {
    let onClose: () -> Void
    let onAgree: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("시행일 \(TermsDocument.effectiveDate)")
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.text2SwiftUI)

                    Text("회사는 회원가입과 서비스 제공을 위해 아래와 같이 개인정보를 수집·이용합니다. 내용이 들어갑니다.")
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .lineSpacing(0)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 24) {
                        detailCard(title: "수집 목적", value: "회원 식별, 주문·배송, 고객 상담 (내용이 들어갑니다.)")
                        detailCard(title: "수집 항목", value: "000")
                        detailCard(title: "보유·이용 기간", value: "000")
                    }

                    Text("동의를 거부할 권리가 있으며, 거부하면 회원가입을 할 수 없습니다.")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                }
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
            Text("개인정보 수집·이용 동의")
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
                .accessibilityLabel("개인정보 수집·이용 동의 닫기")
                Spacer()
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private func detailCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Text(value)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(EUMColor.backgroundSwiftUI)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var bottomAction: some View {
        EUMButton(title: "동의하기", size: .large, action: onAgree)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(EUMColor.backgroundSwiftUI)
            .overlay(alignment: .top) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            }
    }
}
