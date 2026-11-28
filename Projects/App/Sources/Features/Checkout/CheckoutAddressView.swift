import SwiftUI

struct CheckoutOrderItem: Identifiable, Equatable {
    let id: String
    let title: String
    let option: String
    let quantity: Int
    let price: String

    static let mockItems = [
        CheckoutOrderItem(id: "checkout-1", title: "제품명", option: "옵션: 옵션명", quantity: 1, price: "₩00,000"),
        CheckoutOrderItem(id: "checkout-2", title: "제품명", option: "옵션: 옵션명", quantity: 1, price: "₩00,000")
    ]
}

@MainActor
final class CheckoutAddressViewModel: ObservableObject {
    @Published private(set) var isOrderItemsExpanded = true

    let orderItems = CheckoutOrderItem.mockItems

    var orderSummaryTitle: String {
        orderItems.count > 1 ? "\(orderItems[0].title) 외 \(orderItems.count - 1)건" : orderItems.first?.title ?? "주문 상품"
    }

    func toggleOrderItems() {
        isOrderItemsExpanded.toggle()
    }
}

struct CheckoutAddressView: View {
    @StateObject private var viewModel = CheckoutAddressViewModel()
    @State private var presentedMessage: String?
    @State private var isShowingDeliveryRequest = false
    @State private var deliveryRequest = "선택해 주세요"

    let onBack: () -> Void
    let onNext: () -> Void
    let onAddressChange: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            CheckoutProgress(currentStep: 1)
            checkoutContent
            bottomAction
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
        .fullScreenCover(isPresented: $isShowingDeliveryRequest) {
            DeliveryRequestView(initialSelection: deliveryRequest) {
                deliveryRequest = $0
            }
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

    private var checkoutContent: some View {
        ScrollView {
            VStack(spacing: 8) {
                addressSection
                deliveryRequestSection
                deliveryMethodSection
                orderItemsSection
                paymentSummary
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var addressSection: some View {
        sectionCard("배송지 정보") {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("홍길동")
                        .font(EUMTypography.labelLarge)
                        .tracking(-0.16)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("010-0000-0000")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                    Spacer(minLength: 0)
                    EUMButton(title: "변경", kind: .secondary, size: .small) {
                        onAddressChange()
                    }
                    .fixedSize()
                }

                Text("기본 배송지")
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(EUMColor.inverseSwiftUI)
                    .padding(.horizontal, 6)
                    .frame(height: 20)
                    .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))

                Text("서울특별시 00구 00로 00\n00빌딩 000호")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .lineSpacing(2)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var deliveryRequestSection: some View {
        sectionCard("배송 요청사항") {
            Button {
                isShowingDeliveryRequest = true
            } label: {
                HStack(spacing: 8) {
                    Text(deliveryRequest == "선택해 주세요" ? "배송 요청사항을 선택해 주세요" : deliveryRequest)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(deliveryRequest == "선택해 주세요" ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("ProductOptionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).strokeBorder(EUMColor.lineControlSwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("배송 요청사항 선택")
            .accessibilityIdentifier("checkout-delivery-request")
        }
    }

    private var deliveryMethodSection: some View {
        sectionCard("배송 방법") {
            HStack {
                Text("일반 배송 (2~3일)")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                Spacer()
                Text("무료")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
            }
            .foregroundStyle(EUMColor.text1SwiftUI)
        }
    }

    private var orderItemsSection: some View {
        sectionCard("주문 상품") {
            HStack {
                Text(viewModel.orderSummaryTitle)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                Button {
                    viewModel.toggleOrderItems()
                } label: {
                    HStack(spacing: 2) {
                        Text(viewModel.isOrderItemsExpanded ? "접기" : "펼치기")
                            .font(EUMTypography.bodySmall)
                            .tracking(-0.07)
                        Image("ProductOptionChevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(viewModel.isOrderItemsExpanded ? 180 : 0))
                    }
                    .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.isOrderItemsExpanded ? "주문 상품 접기" : "주문 상품 펼치기")
            }
            .padding(.bottom, 6)

            if viewModel.isOrderItemsExpanded {
                VStack(spacing: 6) {
                    ForEach(Array(viewModel.orderItems.enumerated()), id: \.element.id) { index, item in
                        if index > 0 {
                            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                        }
                        CheckoutOrderItemRow(item: item)
                    }
                }
            }
        }
    }

    private var paymentSummary: some View {
        HStack {
            Text("결제 예정 금액")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer()
            Text("₩00,000")
                .font(.custom(EUMFontName.bold, size: 16))
                .tracking(-0.08)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .eumCardBackground(cornerRadius: 16)
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            EUMButton(title: "다음", size: .large, action: onNext)
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    /// Figma checkout section: r16 card, 32 pt title row, 16/20/20 pt body insets.
    private func sectionCard<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(height: 32)
                .padding(.horizontal, 16)
                .accessibilityAddTraits(.isHeader)
            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .eumCardBackground(cornerRadius: 16)
    }
}

struct CheckoutProgress: View {
    let currentStep: Int
    var marksCurrentStepComplete = false

    private let titles = ["배송지", "결제", "완료"]

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(titles.indices, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(index + 1 <= currentStep ? EUMColor.text1SwiftUI : EUMColor.lineSwiftUI)
                        .frame(height: 1.5)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 11.25)
                }
                VStack(spacing: 6) {
                    let isComplete = index + 1 < currentStep || (marksCurrentStepComplete && index + 1 == currentStep)
                    Group {
                        if isComplete {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(EUMColor.inverseSwiftUI)
                        } else {
                            Text("\(index + 1)")
                                .font(EUMTypography.captionMedium)
                                .foregroundStyle(index + 1 == currentStep ? EUMColor.inverseSwiftUI : EUMColor.text3SwiftUI)
                        }
                    }
                    .frame(width: 24, height: 24)
                    .background(
                        isComplete || index + 1 == currentStep ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI,
                        in: Circle()
                    )
                    .overlay {
                        Circle().strokeBorder(
                            isComplete || index + 1 == currentStep ? Color.clear : EUMColor.lineStrongSwiftUI,
                            lineWidth: 1.5
                        )
                    }
                    Text(titles[index])
                        .font(index + 1 <= currentStep ? EUMTypography.captionMedium : EUMTypography.captionRegular)
                        .foregroundStyle(index + 1 <= currentStep ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                }
                .fixedSize()
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 12)
        .frame(height: 72, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(EUMColor.backgroundSwiftUI)
    }
}

private struct CheckoutOrderItemRow: View {
    let item: CheckoutOrderItem

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: EUMRadius.medium)
                .fill(EUMColor.surfaceSecondarySwiftUI)
                .frame(width: 56, height: 56)
                .overlay {
                    Image("ProductPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("\(item.option) · \(item.quantity)개")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text(item.price)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct CheckoutAddressViewPreview: PreviewProvider {
    static var previews: some View {
        CheckoutAddressView(onBack: {}, onNext: {}, onAddressChange: {})
    }
}
