import SwiftUI

struct ProductShippingPolicyView: View {
    let product: HomeProduct
    let onBack: () -> Void

    private let policy = ProductShippingPolicy.sample

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "배송·교환 안내",
                backAccessibilityLabel: "상품 상세로 돌아가기",
                backAccessibilityIdentifier: "shipping-policy-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(EUMTypography.heading3)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("상품 배송 및 교환·반품 안내")
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    }

                    VStack(spacing: 0) {
                        policyRow(title: "배송", value: policy.delivery)
                        divider
                        policyRow(title: "교환·반품", value: policy.exchangeAndReturnPeriod)
                        divider
                        policyRow(title: "반품 배송비", value: policy.returnShippingFee)
                    }
                    .padding(.horizontal, 16)
                    .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))

                    ReturnRequestNotice(
                        message: "표시된 수치와 조건은 현재 상품 상세의 샘플 문구입니다. 실제 상품별 배송·교환 정책은 운영 정보 연동 전까지 확정 정보로 사용할 수 없습니다."
                    )
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private func policyRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(width: 88, alignment: .leading)
            Text(value)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 14)
    }

    private var divider: some View {
        EUMColor.lineSwiftUI.frame(height: 1)
    }
}
