import Combine
import Foundation

struct WithdrawalReasonOption: Identifiable, Equatable {
    let id: String
    let title: String
}

@MainActor
final class AccountWithdrawalReasonViewModel: ObservableObject {
    @Published var selectedReasonID = "other"
    @Published var reasonDetail = "입력한 내용"
    @Published var password = "password"
    @Published var isPasswordVisible = false

    let reasonOptions = (1...5).map { WithdrawalReasonOption(id: "reason-\($0)", title: "탈퇴 사유") } + [
        WithdrawalReasonOption(id: "other", title: "기타")
    ]

    let reasonDetailLimit = 200

    var isOtherSelected: Bool { selectedReasonID == "other" }
    var reasonDetailCount: Int { reasonDetail.count }
    var canSubmit: Bool { !selectedReasonID.isEmpty && !password.isEmpty && (!isOtherSelected || !reasonDetail.isEmpty) }

    func updateReasonDetail(_ value: String) {
        reasonDetail = String(value.prefix(reasonDetailLimit))
    }
}
