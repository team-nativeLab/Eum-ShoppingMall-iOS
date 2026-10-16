import SwiftUI

struct CheckoutPaymentView: View {
    @StateObject private var viewModel: CheckoutPaymentViewModel
    @State private var presentedMessage: String?

    let onBack: () -> Void
    let onPaymentComplete: (CheckoutPaymentMethod) -> Void

    private let horizontalInset: CGFloat = 20

    init(
        onBack: @escaping () -> Void,
        onPaymentComplete: @escaping (CheckoutPaymentMethod) -> Void
    ) {
        self.init(
            onBack: onBack,
            onPaymentComplete: onPaymentComplete,
            viewModel: CheckoutPaymentViewModel()
        )
    }

    init(
        onBack: @escaping () -> Void,
        onPaymentComplete: @escaping (CheckoutPaymentMethod) -> Void,
        viewModel: CheckoutPaymentViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onPaymentComplete = onPaymentComplete
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            CheckoutProgress(currentStep: 2)
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            paymentContent
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("주문하기")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("이전 화면")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var paymentContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                discountSection
                paymentMethodSection
                receiptSection
                paymentAmountSection
                agreementSection
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var discountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            CheckoutPaymentSectionHeading(title: "할인")

            Button {
                presentedMessage = "사용 가능한 쿠폰이 없어요."
            } label: {
                HStack {
                    Text("쿠폰")
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Spacer()
                    Text("사용 가능 \(viewModel.availableCouponCount)장")
                        .foregroundStyle(EUMColor.text2SwiftUI)
                    Image("ProductOptionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(-90))
                }
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("쿠폰, 사용 가능 \(viewModel.availableCouponCount)장")

            HStack(spacing: 8) {
                Text("적립금")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                Text("\(viewModel.availablePoints.formatted())원")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                EUMButton(title: "전액 사용", kind: .secondary, size: .small) {
                    presentedMessage = "사용 가능한 적립금이 없어요."
                }
                .fixedSize()
            }
            .frame(height: 48)
        }
        .padding(.horizontal, horizontalInset)
        .padding(.bottom, 12)
    }

    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            CheckoutPaymentSectionHeading(title: "결제수단")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(CheckoutPaymentMethod.allCases) { method in
                    CheckoutPaymentMethodButton(method: method, isSelected: viewModel.selectedPaymentMethod == method) {
                        viewModel.selectPaymentMethod(method)
                    }
                }
            }
        }
        .padding(.horizontal, horizontalInset)
        .padding(.top, 4)
        .padding(.bottom, 20)
        .overlay(alignment: .top) { divider }
    }

    private var receiptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            CheckoutPaymentSectionHeading(title: "증빙 서류")
            HStack(spacing: 20) {
                ForEach(CheckoutReceiptOption.allCases) { option in
                    receiptOption(option)
                }
            }
            if viewModel.selectedReceiptOption == .taxInvoice {
                CheckoutTaxInvoiceBusinessInfo(viewModel: viewModel)
            } else if viewModel.selectedReceiptOption == .cashReceipt {
                CheckoutCashReceiptPanel(viewModel: viewModel)
            }
        }
        .padding(.horizontal, horizontalInset)
        .padding(.top, 4)
        .padding(.bottom, 20)
        .overlay(alignment: .top) { divider }
    }

    private func receiptOption(_ option: CheckoutReceiptOption) -> some View {
        let isSelected = viewModel.selectedReceiptOption == option
        return CheckoutReceiptOptionButton(option: option, isSelected: isSelected) {
            viewModel.selectReceiptOption(option)
        }
    }

    private var paymentAmountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            CheckoutPaymentSectionHeading(title: "결제 금액")
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    amountRow(title: "상품금액", amount: "₩00,000")
                    amountRow(title: "배송비", amount: "₩0")
                    amountRow(title: "할인", amount: "-₩0")
                }
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(height: 1)
                    .padding(.vertical, 12)
                HStack {
                    Text("최종 결제금액")
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Spacer()
                    Text("₩00,000")
                        .font(.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                        .tracking(-0.6)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
            }
            .padding(20)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
        .padding(.horizontal, horizontalInset)
        .padding(.top, 4)
        .padding(.bottom, 20)
        .overlay(alignment: .top) { divider }
    }

    private func amountRow(title: String, amount: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Spacer()
            Text(amount)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .font(EUMTypography.bodySmall)
        .tracking(-0.07)
    }

    private var agreementSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Button {
                    viewModel.toggleOrderAgreement()
                } label: {
                    HStack(spacing: 8) {
                    agreementCheckbox
                    Text("주문 내용 확인 및 결제 동의 (필수)")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("주문 내용 확인 및 결제 동의")
                .accessibilityValue(viewModel.isOrderAgreementAccepted ? "동의함" : "동의하지 않음")

                Spacer(minLength: 0)
                Button {
                    presentedMessage = "주문 내용과 결제 조건을 확인해 주세요."
                } label: {
                    Image("ProductOptionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .frame(width: 28, height: 36)
                        .rotationEffect(.degrees(-90))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("주문 동의 상세 보기")
            }

            Text("필수 약관에 동의하면 결제할 수 있습니다.")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(.horizontal, horizontalInset)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .overlay(alignment: .top) { divider }
    }

    private var agreementCheckbox: some View {
        RoundedRectangle(cornerRadius: EUMRadius.small)
            .fill(viewModel.isOrderAgreementAccepted ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
            .frame(width: 20, height: 20)
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .stroke(viewModel.isOrderAgreementAccepted ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI, lineWidth: 1.5)
            }
            .overlay {
                if viewModel.isOrderAgreementAccepted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                }
            }
            .accessibilityHidden(true)
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            EUMButton(title: "₩00,000 결제하기", size: .large) {
                onPaymentComplete(viewModel.selectedPaymentMethod)
            }
                .disabled(!viewModel.canPay)
                .padding(.horizontal, horizontalInset)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { divider }
    }

    private var divider: some View {
        Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
    }

}

struct CheckoutPaymentViewPreview: PreviewProvider {
    static var previews: some View {
        CheckoutPaymentView(
            onBack: {},
            onPaymentComplete: { _ in },
            viewModel: CheckoutPaymentViewModel(
                initialReceiptOption: .cashReceipt,
                initialPaymentMethod: .bankTransfer,
                initialCashReceiptPurpose: .expenseEvidence
            )
        )
    }
}
