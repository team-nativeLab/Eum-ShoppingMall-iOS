import Combine
import Foundation

@MainActor
final class ProfileEditViewModel: ObservableObject {
    let email = "example@email.com"
    let businessNumber = "000-00-00000"

    @Published var name = "홍길동"
    @Published var phoneNumber = "010-0000-0000"
    @Published var companyName = "회사명"
    @Published var department = ""
    @Published var agreesToSMS = true
    @Published var agreesToEmail = false

    let businessNumberNotice = "사업자등록번호 변경은 고객센터로 문의해 주세요."
    let marketingNotice = "주문·배송 알림은 수신 동의와 관계없이 발송됩니다."

    func save() -> String {
        "회원 정보 저장은 계정 서비스 연동 후 이용할 수 있어요."
    }
}
