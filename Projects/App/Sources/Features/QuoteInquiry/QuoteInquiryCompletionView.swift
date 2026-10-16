import SwiftUI

struct QuoteInquiryCompletionView: View {
    let details: QuoteInquiryCompletionDetails
    let onClose: () -> Void
    let onContinueShopping: () -> Void
    let onViewInquiries: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 32) {
                    completionMessage
                    inquirySummary
                    progressSteps
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("견적 문의")
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
                .accessibilityLabel("닫기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var completionMessage: some View {
        VStack(spacing: 24) {
            Image("WithdrawalComplete")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 64, height: 64)
                .background(EUMColor.text1SwiftUI, in: Circle())
                .accessibilityHidden(true)
            VStack(spacing: 8) {
                Text("견적 문의가 접수되었습니다")
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .multilineTextAlignment(.center)
                Text("문의번호 \(details.inquiryNumber)")
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Text("담당자가 확인한 뒤 영업일 기준 0일 이내에\n연락드립니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 40)
        .frame(maxWidth: .infinity)
    }

    private var inquirySummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            summaryRow(title: "문의 유형", value: details.inquiryType)
            summaryRow(title: "회사명", value: details.companyName)
            summaryRow(title: "담당자", value: details.contactName)
            summaryRow(title: "문의 품목", value: details.productSummary)
            summaryRow(title: "희망 납기", value: details.deliveryDate)
        }
        .font(EUMTypography.bodySmall)
        .tracking(-0.07)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var progressSteps: some View {
        HStack(spacing: 8) {
            Text("접수")
            Image(systemName: "arrow.right")
            Text("상담중")
            Image(systemName: "arrow.right")
            Text("견적 발송")
            Image(systemName: "arrow.right")
            Text("완료")
        }
        .font(EUMTypography.captionRegular)
        .foregroundStyle(EUMColor.text3SwiftUI)
        .frame(maxWidth: .infinity)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .accessibilityElement(children: .combine)
    }

    private var bottomActions: some View {
        VStack(spacing: 8) {
            EUMButton(title: "쇼핑 계속하기", kind: .secondary, size: .large, action: onContinueShopping)
            EUMButton(title: "문의 내역 보기", size: .large, action: onViewInquiries)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }
}

struct QuoteInquiryCompletionViewPreview: PreviewProvider {
    static var previews: some View {
        QuoteInquiryCompletionView(
            details: QuoteInquiryCompletionDetails(
                inquiryNumber: "Q-00000000-000",
                inquiryType: "맞춤 제작",
                companyName: "회사명",
                contactName: "홍길동",
                productSummary: "제품명 외 0건",
                deliveryDate: "0000.00.00"
            ),
            onClose: {},
            onContinueShopping: {},
            onViewInquiries: {}
        )
    }
}
