import SwiftUI

struct CheckoutCompletedOrder: Equatable {
    let orderNumber: String
    let paymentAmount: String
    let paymentMethod: String
    let shippingAddress: String

    static let mock = CheckoutCompletedOrder(
        orderNumber: "0000000000",
        paymentAmount: "₩00,000",
        paymentMethod: "신용카드",
        shippingAddress: "서울특별시 00구 00로 00"
    )
}

@MainActor
final class CheckoutCompleteViewModel: ObservableObject {
    let order = CheckoutCompletedOrder.mock
}

struct CheckoutCompleteView: View {
    @StateObject private var viewModel = CheckoutCompleteViewModel()

    let onClose: () -> Void
    let onContinueShopping: () -> Void
    let onOrderDetails: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            CheckoutProgress(currentStep: 3, marksCurrentStepComplete: true)
            completionContent
            Spacer(minLength: 0)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("주문 완료")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("주문 완료 닫기")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var completionContent: some View {
        VStack(spacing: 32) {
            VStack(spacing: 24) {
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(EUMColor.inverseSwiftUI)
                    .frame(width: 64, height: 64)
                    .background(EUMColor.text1SwiftUI, in: Circle())
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("주문이 완료되었습니다")
                        .font(.custom("NotoSansKR-Bold", size: 22))
                        .tracking(-0.44)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .accessibilityAddTraits(.isHeader)

                    Text("주문번호 \(viewModel.order.orderNumber)")
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 40)

            orderSummary
        }
    }

    private var orderSummary: some View {
        VStack(spacing: 12) {
            summaryRow(title: "결제금액", value: viewModel.order.paymentAmount, emphasized: true)
            summaryRow(title: "결제수단", value: viewModel.order.paymentMethod)
            summaryRow(title: "배송지", value: viewModel.order.shippingAddress)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private func summaryRow(title: String, value: String, emphasized: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(title)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(emphasized ? .custom("NotoSansKR-Bold", size: 16) : EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var bottomActions: some View {
        VStack(spacing: 8) {
            EUMButton(title: "쇼핑 계속하기", kind: .secondary, size: .large, action: onContinueShopping)
            EUMButton(title: "주문 상세 보기", size: .large, action: onOrderDetails)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(EUMColor.backgroundSwiftUI)
    }
}

struct CheckoutCompleteViewPreview: PreviewProvider {
    static var previews: some View {
        CheckoutCompleteView(onClose: {}, onContinueShopping: {}, onOrderDetails: {})
    }
}
