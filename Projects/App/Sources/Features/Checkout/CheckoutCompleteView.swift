import SwiftUI
import UIKit

struct CheckoutCompletedOrder: Equatable {
    let orderNumber: String
    let paymentAmount: String
    let paymentMethod: CheckoutPaymentMethod
    let shippingAddress: String

    static let mock = CheckoutCompletedOrder(
        orderNumber: "0000000000",
        paymentAmount: "₩00,000",
        paymentMethod: .creditCard,
        shippingAddress: "서울특별시 00구 00로 00"
    )
}

@MainActor
final class CheckoutCompleteViewModel: ObservableObject {
    let order: CheckoutCompletedOrder
    let bankName = "00은행"
    let accountNumber = "000-000000-00000"
    let accountHolder = "예금주명"
    let depositDeadline = "0000.00.00 00:00까지"

    init(paymentMethod: CheckoutPaymentMethod = .creditCard) {
        order = CheckoutCompletedOrder(
            orderNumber: CheckoutCompletedOrder.mock.orderNumber,
            paymentAmount: CheckoutCompletedOrder.mock.paymentAmount,
            paymentMethod: paymentMethod,
            shippingAddress: CheckoutCompletedOrder.mock.shippingAddress
        )
    }
}

struct CheckoutCompleteView: View {
    @StateObject private var viewModel: CheckoutCompleteViewModel
    @State private var didCopyAccountNumber = false

    let onClose: () -> Void
    let onContinueShopping: () -> Void
    let onOrderDetails: () -> Void

    init(
        paymentMethod: CheckoutPaymentMethod = .creditCard,
        onClose: @escaping () -> Void,
        onContinueShopping: @escaping () -> Void,
        onOrderDetails: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: CheckoutCompleteViewModel(paymentMethod: paymentMethod))
        self.onClose = onClose
        self.onContinueShopping = onContinueShopping
        self.onOrderDetails = onOrderDetails
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 0) {
                    CheckoutProgress(currentStep: 3, marksCurrentStepComplete: true)
                    completionContent
                }
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
            Text("주문 완료")
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
                .accessibilityLabel("주문 완료 닫기")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var completionContent: some View {
        VStack(spacing: 32) {
            completionHeader

            if viewModel.order.paymentMethod == .virtualAccount {
                virtualAccountDetails
                depositWarning
                virtualOrderSummary
            } else {
                orderSummary
            }
        }
    }

    private var completionHeader: some View {
        VStack(spacing: 24) {
                Image("WithdrawalComplete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
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
                    if viewModel.order.paymentMethod == .virtualAccount {
                        Text("입금 기한까지 입금하면 주문이 확정됩니다.")
                            .font(EUMTypography.bodySmall)
                            .tracking(-0.07)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    }
                }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private var virtualAccountDetails: some View {
        VStack(spacing: 12) {
            virtualSummaryRow(title: "입금 은행", value: viewModel.bankName)
            HStack(alignment: .center, spacing: 12) {
                virtualSummaryLabel("계좌번호")
                Text(viewModel.accountNumber)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                EUMButton(
                    title: didCopyAccountNumber ? "복사됨" : "복사",
                    kind: .secondary,
                    size: .small
                ) {
                    UIPasteboard.general.string = viewModel.accountNumber
                    didCopyAccountNumber = true
                }
                .fixedSize()
            }
            virtualSummaryRow(title: "예금주", value: viewModel.accountHolder)
            virtualSummaryRow(title: "입금 금액", value: viewModel.order.paymentAmount, emphasized: true)
            virtualSummaryRow(title: "입금 기한", value: viewModel.depositDeadline)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private var depositWarning: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 14))
                .accessibilityHidden(true)
            Text("입금 기한이 지나면 주문이 자동으로 취소됩니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Spacer(minLength: 0)
        }
        .foregroundStyle(EUMColor.text2SwiftUI)
        .padding(.horizontal, 14)
        .frame(height: 44)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private var virtualOrderSummary: some View {
        VStack(spacing: 12) {
            summaryRow(title: "결제수단", value: viewModel.order.paymentMethod.rawValue)
            summaryRow(title: "배송지", value: viewModel.order.shippingAddress)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private var orderSummary: some View {
        VStack(spacing: 12) {
            summaryRow(title: "결제금액", value: viewModel.order.paymentAmount, emphasized: true)
            summaryRow(title: "결제수단", value: viewModel.order.paymentMethod.rawValue)
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

    private func summaryLabel(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.bodySmall)
            .tracking(-0.07)
            .foregroundStyle(EUMColor.text3SwiftUI)
            .frame(width: 72, alignment: .leading)
    }

    private func virtualSummaryRow(title: String, value: String, emphasized: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            virtualSummaryLabel(title)
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

    private func virtualSummaryLabel(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.bodySmall)
            .tracking(-0.07)
            .foregroundStyle(EUMColor.text3SwiftUI)
            .frame(width: 84, alignment: .leading)
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
