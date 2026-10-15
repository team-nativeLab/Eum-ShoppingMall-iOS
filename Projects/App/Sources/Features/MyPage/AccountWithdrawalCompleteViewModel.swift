import Foundation

struct AccountWithdrawalCompletion: Equatable {
    let withdrawalDate: String
    let rejoinAvailableDate: String

    static let mock = AccountWithdrawalCompletion(
        withdrawalDate: "0000.00.00 00:00",
        rejoinAvailableDate: "0000.00.00 이후"
    )
}

struct AccountWithdrawalCompleteViewModel {
    let completion: AccountWithdrawalCompletion

    init(completion: AccountWithdrawalCompletion = .mock) {
        self.completion = completion
    }

    let title = "회원 탈퇴가 완료되었습니다"
    let description = "그동안 이음산업건설을 이용해 주셔서 감사합니다.\n언제든 다시 찾아 주세요."
    let retentionNotice = "주문·결제 기록은 관련 법령에 따라\n0년간 보관된 뒤 파기됩니다."
}
