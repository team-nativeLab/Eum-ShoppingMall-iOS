import Combine

@MainActor
final class AccountWithdrawalNoticeViewModel: ObservableObject {
    @Published var hasAgreedToWithdrawal = false

    let memberName = "홍길동"
    let couponCount = 0
    let pointsBalance = 0

    let notices = [
        "탈퇴하면 계정 정보(이메일, 이름, 휴대폰 번호, 배송지)와 찜한 상품, 장바구니, 최근 본 상품이 삭제되며 복구할 수 없습니다.",
        "보유한 쿠폰과 적립금은 탈퇴 즉시 소멸되며, 재가입해도 다시 지급되지 않습니다.",
        "관련 법령에 따라 주문·결제 기록은 0년, 소비자 불만 및 분쟁 처리 기록은 0년간 보관한 뒤 파기합니다.",
        "탈퇴한 이메일로는 0일 동안 다시 가입할 수 없습니다.",
        "작성한 견적 문의와 1:1 문의 내역은 탈퇴 후 조회하거나 수정할 수 없습니다."
    ]
}
