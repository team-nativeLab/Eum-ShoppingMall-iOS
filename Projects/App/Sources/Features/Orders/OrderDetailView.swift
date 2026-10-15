import SwiftUI

struct OrderDetailView: View {
    @StateObject private var viewModel: OrderDetailViewModel

    let onBack: () -> Void
    let onTrackDelivery: () -> Void
    let onReturnExchange: () -> Void
    let onDocumentDownload: () -> Void
    let onReceipt: () -> Void

    init(
        order: OrderHistoryItem,
        onBack: @escaping () -> Void,
        onTrackDelivery: @escaping () -> Void,
        onReturnExchange: @escaping () -> Void,
        onDocumentDownload: @escaping () -> Void,
        onReceipt: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: OrderDetailViewModel(order: order))
        self.onBack = onBack
        self.onTrackDelivery = onTrackDelivery
        self.onReturnExchange = onReturnExchange
        self.onDocumentDownload = onDocumentDownload
        self.onReceipt = onReceipt
    }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 44)
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    orderHeading
                    OrderDetailProductSection(products: viewModel.products)
                    OrderDetailCard(title: "배송지") {
                        OrderDetailKeyValueRows(rows: viewModel.shippingRows, labelWidth: 88)
                    }
                    paymentSection
                    OrderDetailCard {
                        OrderDetailSummaryRow(title: "적립 예정 적립금", value: viewModel.expectedPoints, isMedium: true)
                    }
                    documentActions
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("주문 상세")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("주문내역으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var orderHeading: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(viewModel.order.orderDate) 주문")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text("주문번호 \(viewModel.order.orderNumber)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var paymentSection: some View {
        OrderDetailCard(title: "결제 정보") {
            VStack(spacing: 12) {
                ForEach(viewModel.paymentRows) { row in
                    OrderDetailSummaryRow(title: row.title, value: row.value)
                }
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(height: 1)
                HStack {
                    Text("총 결제 금액")
                        .font(EUMTypography.labelLarge)
                        .tracking(-0.08)
                    Spacer()
                    Text(viewModel.totalPaid)
                        .font(.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                        .tracking(-0.36)
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                OrderDetailSummaryRow(title: "결제 수단", value: viewModel.paymentMethod)
            }
        }
    }

    private var documentActions: some View {
        VStack(spacing: 0) {
            OrderDetailMenuRow(title: "거래명세서 다운로드", iconName: "OrderDetailDownload", action: onDocumentDownload)
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
                .padding(.horizontal, 20)
            OrderDetailMenuRow(title: "영수증 보기", iconName: "OrderDetailReceipt", action: onReceipt)
        }
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var bottomActions: some View {
        HStack(spacing: 8) {
            EUMButton(title: "배송 조회", size: .large, action: onTrackDelivery)
            EUMButton(title: "교환/반품 신청", kind: .secondary, size: .large, action: onReturnExchange)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background {
            EUMColor.backgroundSwiftUI
                .overlay(alignment: .top) { EUMColor.lineSwiftUI.frame(height: 1) }
        }
    }
}

struct OrderDetailViewPreview: PreviewProvider {
    static var previews: some View {
        OrderDetailView(
            order: OrderHistoryItem.samples[2],
            onBack: {},
            onTrackDelivery: {},
            onReturnExchange: {},
            onDocumentDownload: {},
            onReceipt: {}
        )
    }
}
