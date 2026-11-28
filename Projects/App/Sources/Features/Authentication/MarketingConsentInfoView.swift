import SwiftUI

struct MarketingConsentInfoView: View {
    let onClose: () -> Void

    private let items = [
        ConsentInfoItem(
            title: "수집·이용 목적",
            detail: "할인, 이벤트 및 신규 상품 안내",
            iconAssetName: "MarketingConsentPurpose"
        ),
        ConsentInfoItem(
            title: "수신 채널",
            detail: "앱 푸시, 문자, 이메일",
            iconAssetName: "MarketingConsentChannel"
        ),
        ConsentInfoItem(
            title: "보유 기간",
            detail: "동의 철회 또는 회원 탈퇴 시까지",
            iconAssetName: "MarketingConsentRetention"
        ),
        ConsentInfoItem(
            title: "동의 거부",
            detail: "동의하지 않아도 기본 서비스 이용이 가능합니다.",
            iconAssetName: "MarketingConsentRefusal"
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    Text("수신 동의 항목과 안내 내용을 확인한 후 선택해 주세요.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)

                    VStack(spacing: 12) {
                        ForEach(items) { item in
                            ConsentInfoCard(item: item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .accessibilityAddTraits(.isModal)
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "마케팅 수신 동의",
            backAccessibilityLabel: "마케팅 수신 동의 닫기",
            backAccessibilityIdentifier: "marketing-consent-back",
            onBack: onClose
        ) {
            Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
        }
    }
}

private struct ConsentInfoItem: Identifiable {
    let title: String
    let detail: String
    let iconAssetName: String

    var id: String { title }
}

private struct ConsentInfoCard: View {
    let item: ConsentInfoItem

    var body: some View {
        HStack(spacing: 12) {
            Image(item.iconAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .frame(width: 36, height: 36)
                .background(Color(red: 231 / 255, green: 245 / 255, blue: 241 / 255), in: RoundedRectangle(cornerRadius: 11))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text(item.detail)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 13)
        .frame(height: 80)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}
