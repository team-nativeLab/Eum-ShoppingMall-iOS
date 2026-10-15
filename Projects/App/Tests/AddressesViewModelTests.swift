import XCTest
@testable import EumShoppingMall

@MainActor
final class AddressesViewModelTests: XCTestCase {
    func testMockAddressesHaveOneDefaultAddress() {
        let viewModel = AddressesViewModel()

        XCTAssertEqual(viewModel.addresses.count, 3)
        XCTAssertEqual(viewModel.addresses.filter(\.isDefault).map(\.id), ["address-1"])
    }

    func testChangingDefaultKeepsExactlyOneDefault() {
        let viewModel = AddressesViewModel()

        viewModel.setDefault(addressID: "address-2")

        XCTAssertEqual(viewModel.addresses.filter(\.isDefault).map(\.id), ["address-2"])
    }

    func testDeleteRemovesAddress() {
        let viewModel = AddressesViewModel()

        viewModel.delete(addressID: "address-3")

        XCTAssertEqual(viewModel.addresses.map(\.id), ["address-1", "address-2"])
    }

    func testSaveAppendsNewAddressAndMovesDefaultWhenSelected() {
        let viewModel = AddressesViewModel()
        let newAddress = ShippingAddress(
            id: "address-4", name: "본사", recipient: "홍길동", phoneNumber: "010-1234-5678",
            postalAddress: "(12345)", detailAddress: "서울시", isDefault: true
        )

        viewModel.save(newAddress)

        XCTAssertEqual(viewModel.addresses.count, 4)
        XCTAssertEqual(viewModel.addresses.filter(\.isDefault).map(\.id), ["address-4"])
    }
}
