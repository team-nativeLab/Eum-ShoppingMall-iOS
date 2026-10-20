import Combine
import Foundation

@MainActor
final class AddressEditorViewModel: ObservableObject {
    @Published var name: String
    @Published var recipient: String
    @Published var phoneNumber: String
    @Published var postalCode: String
    @Published var address: String
    @Published var detailAddress: String
    @Published var deliveryRequest: String
    @Published var isDefault: Bool

    private let addressID: String

    init(address: ShippingAddress? = nil) {
        addressID = address?.id ?? UUID().uuidString
        name = address?.name ?? ""
        recipient = address?.recipient ?? "홍길동"
        phoneNumber = address == nil ? "010-0000" : address?.phoneNumber ?? ""
        postalCode = address?.postalAddress.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "") ?? "00000"
        self.address = address?.detailAddress ?? "주소"
        detailAddress = ""
        deliveryRequest = "선택해 주세요"
        isDefault = address?.isDefault ?? false
    }

    var phoneError: String? {
        phoneNumber.range(of: #"^010-\d{4}-\d{4}$"#, options: .regularExpression) == nil
            ? "휴대폰 번호 형식이 올바르지 않습니다."
            : nil
    }

    func makeAddress() -> ShippingAddress? {
        guard phoneError == nil else { return nil }
        return ShippingAddress(
            id: addressID,
            name: name.isEmpty ? "배송지명" : name,
            recipient: recipient,
            phoneNumber: phoneNumber,
            postalAddress: "(\(postalCode))",
            detailAddress: detailAddress.isEmpty ? address : "\(address) \(detailAddress)",
            isDefault: isDefault
        )
    }

    func applyAddressSearchResult(_ result: AddressSearchResult) {
        postalCode = result.postalCode
        address = result.address
    }
}
