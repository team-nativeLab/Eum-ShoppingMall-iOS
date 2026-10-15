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
}
