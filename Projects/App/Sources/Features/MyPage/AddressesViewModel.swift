import Combine
import Foundation

struct ShippingAddress: Identifiable {
    let id: String
    var name: String
    var recipient: String
    var phoneNumber: String
    var postalAddress: String
    var detailAddress: String
    var isDefault: Bool
}

@MainActor
final class AddressesViewModel: ObservableObject {
    @Published private(set) var addresses = [
        ShippingAddress(
            id: "address-1", name: "배송지명", recipient: "홍길동", phoneNumber: "010-0000-0000",
            postalAddress: "(00000)", detailAddress: "주소 상세주소", isDefault: true
        ),
        ShippingAddress(
            id: "address-2", name: "배송지명", recipient: "홍길동", phoneNumber: "010-0000-0000",
            postalAddress: "(00000)", detailAddress: "주소 상세주소", isDefault: false
        ),
        ShippingAddress(
            id: "address-3", name: "배송지명", recipient: "홍길동", phoneNumber: "010-0000-0000",
            postalAddress: "(00000)", detailAddress: "주소 상세주소", isDefault: false
        )
    ]

    let addressLimitNotice = "배송지는 최대 0개까지 등록할 수 있습니다."

    func setDefault(addressID: String) {
        guard addresses.contains(where: { $0.id == addressID }) else { return }
        addresses = addresses.map { address in
            var updated = address
            updated.isDefault = address.id == addressID
            return updated
        }
    }

    func delete(addressID: String) {
        addresses.removeAll { $0.id == addressID }
    }

    func save(_ address: ShippingAddress) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            addresses[index] = address
        } else {
            addresses.append(address)
        }
        if address.isDefault {
            setDefault(addressID: address.id)
        }
    }
}
