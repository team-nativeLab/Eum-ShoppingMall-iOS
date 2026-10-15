import Combine
import Foundation

struct Coupon: Identifiable {
    let id: String
    let discount: String
    let title: String
    let condition: String
    let expiry: String
    let scope: String
    var remainingDays: String?
}

enum CouponListTab: String, CaseIterable, Identifiable {
    case available = "사용 가능 0"
    case completed = "사용 완료·만료"

    var id: String { rawValue }
}

@MainActor
final class CouponsViewModel: ObservableObject {
    @Published var selectedTab = CouponListTab.available
    @Published private(set) var availableCoupons = [
        Coupon(
            id: "coupon-1", discount: "00%", title: "쿠폰명",
            condition: "₩00,000 이상 구매 시 · 최대 ₩0,000 할인",
            expiry: "0000.00.00까지", scope: "적용 상품", remainingDays: "D-0"
        ),
        Coupon(
            id: "coupon-2", discount: "₩0,000", title: "쿠폰명",
            condition: "₩00,000 이상 구매 시 · 최대 ₩0,000 할인",
            expiry: "0000.00.00까지", scope: "적용 상품"
        ),
        Coupon(
            id: "coupon-3", discount: "00%", title: "쿠폰명",
            condition: "₩00,000 이상 구매 시 · 최대 ₩0,000 할인",
            expiry: "0000.00.00까지", scope: "전 상품"
        ),
        Coupon(
            id: "coupon-4", discount: "₩00,000", title: "배송비 쿠폰",
            condition: "₩00,000 이상 구매 시 · 최대 ₩0,000 할인",
            expiry: "0000.00.00까지", scope: "배송비"
        )
    ]
    @Published private(set) var completedCoupons: [Coupon] = []

    var couponsForSelectedTab: [Coupon] {
        selectedTab == .available ? availableCoupons : completedCoupons
    }

    func registerCoupon(code: String) -> String {
        code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "쿠폰 코드를 입력해 주세요."
            : "쿠폰 등록은 서비스 연동 후 이용할 수 있어요."
    }
}
