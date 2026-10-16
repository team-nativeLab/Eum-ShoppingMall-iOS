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

    let onBack: () -> Void
    let onNext: () -> Void
    var onAddressChange: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            topBar
            CheckoutProgress(currentStep: 1)
            checkoutContent
            bottomAction
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
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

    private var checkoutContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                addressSection
                deliveryRequestSection
                deliveryMethodSection
                orderItemsSection
                paymentSummary
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var addressSection: some View {
        VStack(spacing: 0) {
            sectionTitle("배송지 정보")
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
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var deliveryRequestSection: some View {
        VStack(spacing: 0) {
            sectionTitle("배송 요청사항")
            Button {
                presentedMessage = "배송 요청사항 선택 항목은 아직 연결되지 않았어요."
            } label: {
                HStack(spacing: 8) {
                    Text("배송 요청사항을 선택해 주세요")
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("ProductOptionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.text3SwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("배송 요청사항 선택")
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.vertical, 16)
        }
    }

    private var deliveryMethodSection: some View {
        VStack(spacing: 0) {
            sectionTitle("배송 방법")
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
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .frame(height: 56)
        }
    }

    private var orderItemsSection: some View {
        VStack(spacing: 0) {
            sectionTitle("주문 상품")
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
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .frame(height: 40)

            if viewModel.isOrderItemsExpanded {
                VStack(spacing: 8) {
                    ForEach(viewModel.orderItems) { item in
                        CheckoutOrderItemRow(item: item)
                    }
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.bottom, 20)
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
                .font(.custom("NotoSansKR-Bold", size: 16))
                .tracking(-0.08)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .frame(height: 64)
        .background(EUMColor.backgroundSubtleSwiftUI)
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

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .background(EUMColor.backgroundSubtleSwiftUI)
            .accessibilityAddTraits(.isHeader)
    }
}

struct CheckoutProgress: View {
    let currentStep: Int
    var marksCurrentStepComplete = false

    private let titles = ["배송지", "결제", "완료"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(index + 1 <= currentStep ? EUMColor.text1SwiftUI : EUMColor.lineSwiftUI)
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
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
                        Circle().stroke(
                            isComplete || index + 1 == currentStep ? Color.clear : EUMColor.lineStrongSwiftUI,
                            lineWidth: 1
                        )
                    }
                    Text(titles[index])
                        .font(EUMTypography.labelExtraSmall)
                        .foregroundStyle(index + 1 <= currentStep ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                }
                .frame(width: 52)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
}

private struct CheckoutOrderItemRow: View {
    let item: CheckoutOrderItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: EUMRadius.medium)
                .fill(EUMColor.surfaceSwiftUI)
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("\(item.option) · \(item.quantity)개")
                    .font(EUMTypography.captionMedium)
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
        CheckoutAddressView(onBack: {}, onNext: {})
    }
}
