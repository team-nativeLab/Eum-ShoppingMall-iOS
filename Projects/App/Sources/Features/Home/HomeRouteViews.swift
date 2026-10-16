import SwiftUI

struct HomeOrderRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .orderHistory:
            OrderHistoryView(
                onBack: onBack,
                onCancelReturn: { onRoute(.returnHistory(backToOrderHistory: true)) },
                onOrderDetail: { onRoute(.orderDetail($0)) },
                onCancelOrder: { _ in onMessage("주문 취소는 서버 연동 후 이용할 수 있어요.") },
                onTrackDelivery: { _ in onMessage("배송 조회는 서버 연동 후 이용할 수 있어요.") },
                onReorder: { _ in onMessage("다시 담기는 장바구니 연결 후 이용할 수 있어요.") }
            )
        case let .orderDetail(order):
            OrderDetailView(
                order: order,
                onBack: { onRoute(.orderHistory) },
                onTrackDelivery: { onRoute(.deliveryTracking(order)) },
                onReturnExchange: { onRoute(.returnRequest(order)) },
                onDocumentDownload: { onMessage("거래명세서는 주문 서비스 연동 후 다운로드할 수 있어요.") },
                onReceipt: { onMessage("영수증은 주문 서비스 연동 후 확인할 수 있어요.") }
            )
        case let .deliveryTracking(order):
            DeliveryTrackingView(order: order, onBack: { onRoute(.orderDetail(order)) })
        case let .returnRequest(order):
            ReturnRequestView(
                order: order,
                onBack: { onRoute(.orderDetail(order)) },
                onUnavailableKind: { onMessage("\($0.rawValue) 화면은 별도 작업에서 연결할 예정이에요.") },
                onAddressChange: { onMessage("배송지 변경은 배송지 관리 화면 연결 후 이용할 수 있어요.") },
                onSubmit: onMessage
            )
        case let .returnHistory(backToOrderHistory):
            ReturnHistoryView(
                onBack: { backToOrderHistory ? onRoute(.orderHistory) : onBack() },
                onDetail: { _ in onMessage("신청 상세는 서버 연동 후 확인할 수 있어요.") },
                onWithdraw: { _ in onMessage("신청 철회는 서버 연동 후 이용할 수 있어요.") },
                onRejectionReason: { item in onMessage(item.rejectionReason ?? "반려 사유가 없습니다.") }
            )
        case let .quoteDetail(inquiry):
            QuoteDetailView(
                inquiry: inquiry,
                onBack: { onRoute(.accountCollection(.quoteHistory)) },
                onDownload: { fileName in onMessage("\(fileName)은 서비스 연동 후 다운로드할 수 있어요.") },
                onContact: { onMessage("담당자 연락은 서비스 연동 후 이용할 수 있어요.") },
                onRequote: { onMessage("재견적 요청은 서비스 연동 후 이용할 수 있어요.") }
            )
        default:
            EmptyView()
        }
    }
}

struct AccountCollectionRouteView: View {
    let destination: AccountCollectionDestination
    @ObservedObject var addressViewModel: AddressesViewModel
    let onBack: () -> Void
    let onBackToCoupons: () -> Void
    let onBackToVerification: () -> Void
    let onPointsTap: () -> Void
    let onAddAddress: () -> Void
    let onEditAddress: (ShippingAddress) -> Void
    let onAction: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onNewQuoteInquiry: () -> Void
    let onQuoteDocument: () -> Void
    let onOpenQuoteDetail: (QuoteInquiryRecord) -> Void
    let onWithdrawTap: () -> Void

    @ViewBuilder
    var body: some View {
        switch destination {
        case .favorites:
            FavoritesView(onBack: onBack, onProductTap: onProductTap)
        case .recentlyViewed:
            RecentlyViewedView(onBack: onBack, onProductTap: onProductTap)
        case .coupons:
            CouponsView(onBack: onBack, onPointsTap: onPointsTap)
        case .points:
            PointsView(onBack: onBackToCoupons)
        case .editProfile:
            ProfileEditView(onBack: onBackToVerification, onAction: onAction, onWithdrawTap: onWithdrawTap)
        case .addresses:
            AddressesView(viewModel: addressViewModel, onBack: onBack, onAdd: onAddAddress, onEdit: onEditAddress)
        case .quoteHistory:
            QuoteHistoryView(
                onBack: onBack,
                onNewInquiry: onNewQuoteInquiry,
                onDocument: onQuoteDocument,
                onOpenDetail: onOpenQuoteDetail
            )
        case .contactHistory:
            ContactInquiryHistoryView(
                onBack: onBack,
                onNewInquiry: { onAction("1:1 문의 작성 화면은 별도 작업에서 연결됩니다.") },
                onOpenDetail: { _ in onAction("문의 상세 화면은 다음 화면 작업에서 연결됩니다.") }
            )
        }
    }
}

struct AccountVerificationRouteView: View {
    let onBack: () -> Void
    let onVerified: () -> Void
    let onMessage: (String) -> Void

    var body: some View {
        AccountVerificationView(onBack: onBack) { message in
            if let message {
                onMessage(message)
            } else {
                onVerified()
            }
        }
    }
}

struct AddressEditorRouteView: View {
    @State private var presentedMessage: String?

    let address: ShippingAddress?
    let onBack: () -> Void
    let onSave: (ShippingAddress) -> Void

    var body: some View {
        AddressEditorView(
            address: address,
            onBack: onBack,
            onSave: onSave,
            onUnavailableAction: { presentedMessage = $0 }
        )
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var messagePresented: Binding<Bool> {
        Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
