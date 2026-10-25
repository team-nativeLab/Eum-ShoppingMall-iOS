import Combine
import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import UIKit

enum ReturnRequestKind: String, CaseIterable, Identifiable {
    case cancel = "취소"
    case returning = "반품"
    case exchange = "교환"

    var id: String { rawValue }
}

enum ReturnRequestReason: String, CaseIterable, Identifiable {
    case changeOfMind = "단순 변심"
    case defective = "상품 불량·파손"
    case wrongItem = "오배송"
    case delayed = "배송 지연"
    case other = "기타"

    var id: String { rawValue }
}

enum ReturnPickupMethod: String, CaseIterable, Identifiable {
    case courier = "택배 회수"
    case selfShip = "직접 발송"

    var id: String { rawValue }
}

struct ReturnRequestProduct: Identifiable, Equatable {
    let id: String
    let name: String
    let option: String
}

struct ReturnRequestPhoto: Identifiable {
    let id: UUID
    let image: UIImage?

    static func placeholder() -> ReturnRequestPhoto {
        ReturnRequestPhoto(id: UUID(), image: nil)
    }
}

@MainActor
final class ReturnRequestViewModel: ObservableObject {
    @Published var selectedKind = ReturnRequestKind.returning
    @Published var selectedReason = ReturnRequestReason.defective
    @Published var detailedReason = ""
    @Published var pickupMethod = ReturnPickupMethod.courier
    @Published var selectedPhotoItems: [PhotosPickerItem] = []
    @Published private(set) var photos = [ReturnRequestPhoto.placeholder(), .placeholder()]
    @Published private(set) var selectedProductIDs: Set<String> = ["return-product-1"]
    @Published private(set) var quantities = ["return-product-1": 1, "return-product-2": 1]

    let order: OrderHistoryItem
    let products = [
        ReturnRequestProduct(id: "return-product-1", name: "제품명", option: "옵션명 · 주문 0개"),
        ReturnRequestProduct(id: "return-product-2", name: "제품명", option: "옵션명 · 주문 0개")
    ]
    private var loadedPhotoItemCount = 0

    init(order: OrderHistoryItem) {
        self.order = order
        selectedKind = [.awaitingPayment, .paymentComplete, .preparing].contains(order.status) ? .cancel : .returning
    }

    var canSubmit: Bool { !selectedProductIDs.isEmpty }

    var pageTitle: String {
        switch selectedKind {
        case .cancel: "취소 신청"
        case .returning: "반품 신청"
        case .exchange: "교환 신청"
        }
    }

    var submitTitle: String {
        switch selectedKind {
        case .cancel: "취소 신청하기"
        case .returning: "반품 신청하기"
        case .exchange: "교환 신청하기"
        }
    }

    func quantity(for product: ReturnRequestProduct) -> Int {
        quantities[product.id, default: 0]
    }

    func isSelected(_ product: ReturnRequestProduct) -> Bool {
        selectedProductIDs.contains(product.id)
    }

    func toggleProduct(_ product: ReturnRequestProduct) {
        if selectedProductIDs.contains(product.id) {
            selectedProductIDs.remove(product.id)
        } else {
            selectedProductIDs.insert(product.id)
            if quantity(for: product) == 0 {
                quantities[product.id] = 1
            }
        }
    }

    func adjustQuantity(for product: ReturnRequestProduct, by delta: Int) {
        let nextValue = max(0, quantity(for: product) + delta)
        quantities[product.id] = nextValue
        if nextValue == 0 {
            selectedProductIDs.remove(product.id)
        } else {
            selectedProductIDs.insert(product.id)
        }
    }

    func removePhoto(id: UUID) {
        photos.removeAll { $0.id == id }
    }

    func loadSelectedPhotos(from items: [PhotosPickerItem]) async {
        let newItems = items.dropFirst(loadedPhotoItemCount)
        var loadedPhotos: [ReturnRequestPhoto] = []
        for item in newItems {
            guard
                let data = try? await item.loadTransferable(type: Data.self),
                let image = UIImage(data: data)
            else { continue }
            loadedPhotos.append(ReturnRequestPhoto(id: UUID(), image: image))
        }
        photos.append(contentsOf: loadedPhotos)
        loadedPhotoItemCount = items.count
    }

    func submitMessage() -> String {
        guard canSubmit else {
            switch selectedKind {
            case .cancel: return "취소할 상품을 선택해 주세요."
            case .returning: return "반품할 상품을 선택해 주세요."
            case .exchange: return "교환할 상품을 선택해 주세요."
            }
        }
        switch selectedKind {
        case .cancel: return "취소 신청은 주문 서비스 연동 후 접수할 수 있어요."
        case .returning: return "반품 신청은 주문 서비스 연동 후 접수할 수 있어요."
        case .exchange: return "교환 신청은 주문 서비스 연동 후 접수할 수 있어요."
        }
    }

    func makeHistoryItem(applicationNumber: String) -> ReturnHistoryItem {
        let selectedProducts = products.filter { isSelected($0) }
        let firstProduct = selectedProducts.first?.name ?? "제품명"
        let productName = selectedProducts.count > 1 ? "\(firstProduct) 외 \(selectedProducts.count - 1)건" : firstProduct
        let kind: ReturnHistoryKind
        switch selectedKind {
        case .cancel: kind = .cancellation
        case .returning: kind = .returnRequest
        case .exchange: kind = .exchange
        }

        return ReturnHistoryItem(
            id: "return-\(applicationNumber)",
            kind: kind,
            status: .requested,
            orderDate: order.orderDate,
            orderNumber: order.orderNumber,
            productName: productName,
            priceAndQuantity: order.priceAndQuantity,
            refundAmount: "₩00,000",
            applicationNumber: applicationNumber,
            requestReason: selectedReason.rawValue
        )
    }
}
