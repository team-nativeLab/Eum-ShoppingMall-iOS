import XCTest
@testable import EumShoppingMall

@MainActor
final class AddressEditorViewModelTests: XCTestCase {
    func testNewAddressStartsInFigmaInvalidPhoneState() {
        let viewModel = AddressEditorViewModel()

        XCTAssertEqual(viewModel.phoneNumber, "010-0000")
        XCTAssertNotNil(viewModel.phoneError)
        XCTAssertNil(viewModel.makeAddress())
    }

    func testValidPhoneBuildsNewAddressWithChosenDefaultState() {
        let viewModel = AddressEditorViewModel()
        viewModel.name = "본사"
        viewModel.phoneNumber = "010-1234-5678"
        viewModel.detailAddress = "3층"
        viewModel.isDefault = true

        let address = viewModel.makeAddress()

        XCTAssertEqual(address?.name, "본사")
        XCTAssertEqual(address?.phoneNumber, "010-1234-5678")
        XCTAssertEqual(address?.detailAddress, "주소 3층")
        XCTAssertTrue(address?.isDefault == true)
    }

    func testEditingAddressKeepsItsIdentifierAndExistingValue() {
        let original = ShippingAddress(
            id: "existing", name: "현장", recipient: "홍길동", phoneNumber: "010-1234-5678",
            postalAddress: "(12345)", detailAddress: "서울시 강남구", isDefault: false
        )
        let viewModel = AddressEditorViewModel(address: original)

        XCTAssertEqual(viewModel.makeAddress()?.id, "existing")
        XCTAssertEqual(viewModel.makeAddress()?.postalAddress, "(12345)")
        XCTAssertEqual(viewModel.makeAddress()?.detailAddress, "서울시 강남구")
    }
}
