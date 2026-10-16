import SwiftUI

struct AddressesView: View {
    @ObservedObject var viewModel: AddressesViewModel

    let onBack: () -> Void
    let onAdd: () -> Void
    let onEdit: (ShippingAddress) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.addresses) { address in
                        addressCard(address)
                    }
                    Text(viewModel.addressLimitNotice)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            addAddressAction
        }
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "배송지 관리",
            backAccessibilityLabel: "마이페이지로 돌아가기",
            onBack: onBack
        ) {
            Color.clear.frame(width: 44, height: 44)
        }
    }

    private func addressCard(_ address: ShippingAddress) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(address.name)
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                if address.isDefault {
                    Text("기본 배송지")
                        .font(EUMTypography.labelExtraSmall)
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                        .padding(.horizontal, 6)
                        .frame(height: 20)
                        .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                }
            }

            Text("\(address.recipient) · \(address.phoneNumber)")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Text("\(address.postalAddress) \(address.detailAddress)")
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Spacer()
                if !address.isDefault {
                    EUMButton(title: "기본 설정", kind: .ghost, size: .small) {
                        viewModel.setDefault(addressID: address.id)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                EUMButton(title: "수정", kind: .secondary, size: .small) {
                    onEdit(address)
                }
                .fixedSize(horizontal: true, vertical: false)
                if !address.isDefault {
                    EUMButton(title: "삭제", kind: .secondary, size: .small) {
                        viewModel.delete(addressID: address.id)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI)
        .overlay {
            RoundedRectangle(cornerRadius: EUMRadius.large)
                .stroke(address.isDefault ? EUMColor.lineStrongSwiftUI : EUMColor.lineSwiftUI, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var addAddressAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "배송지 추가", size: .large, action: onAdd)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}

struct AddressesViewPreview: PreviewProvider {
    static var previews: some View {
        AddressesView(viewModel: AddressesViewModel(), onBack: {}, onAdd: {}, onEdit: { _ in })
    }
}
