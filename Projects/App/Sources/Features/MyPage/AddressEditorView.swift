import SwiftUI

struct AddressEditorView: View {
    @StateObject private var viewModel: AddressEditorViewModel

    let isEditing: Bool
    let onBack: () -> Void
    let onSave: (ShippingAddress) -> Void
    let onUnavailableAction: (String) -> Void

    init(
        address: ShippingAddress?,
        onBack: @escaping () -> Void,
        onSave: @escaping (ShippingAddress) -> Void,
        onUnavailableAction: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: AddressEditorViewModel(address: address))
        isEditing = address != nil
        self.onBack = onBack
        self.onSave = onSave
        self.onUnavailableAction = onUnavailableAction
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AddressEditorField(title: "배송지명", placeholder: "예: 본사, 현장", text: $viewModel.name)
                    AddressEditorField(title: "받는 분", text: $viewModel.recipient)
                    AddressEditorField(
                        title: "휴대폰 번호",
                        text: $viewModel.phoneNumber,
                        error: viewModel.phoneError
                    )
                    addressSearchRow
                    AddressEditorField(text: $viewModel.address)
                    AddressEditorField(placeholder: "상세 주소를 입력해 주세요", text: $viewModel.detailAddress, isFocused: true)
                    deliveryRequest
                    defaultAddressToggle
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            saveAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text(isEditing ? "배송지 수정" : "배송지 추가")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("배송지 관리로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var addressSearchRow: some View {
        HStack(alignment: .bottom, spacing: 8) {
            AddressEditorField(title: "주소", text: $viewModel.postalCode, isDisabled: true)
            EUMButton(title: "주소 검색", kind: .secondary, size: .medium) {
                onUnavailableAction("주소 검색은 주소 서비스 연동 후 이용할 수 있어요.")
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var deliveryRequest: some View {
        Button {
            onUnavailableAction("배송 요청사항은 배송 옵션 연동 후 선택할 수 있어요.")
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("배송 요청사항")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                HStack {
                    Text(viewModel.deliveryRequest)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                    Spacer()
                    Image("AddressEditorChevronDown")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                .contentShape(Rectangle())
            }
        }
        .buttonStyle(.plain)
    }

    private var defaultAddressToggle: some View {
        Button {
            viewModel.isDefault.toggle()
        } label: {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .fill(viewModel.isDefault ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                    .frame(width: 20, height: 20)
                    .overlay {
                        if viewModel.isDefault {
                            Image("ProfileEditCheck")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                        } else {
                            RoundedRectangle(cornerRadius: EUMRadius.small)
                                .stroke(EUMColor.lineControlSwiftUI, lineWidth: 1.5)
                        }
                    }
                Text("기본 배송지로 설정")
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var saveAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "저장", size: .large) {
                guard let address = viewModel.makeAddress() else {
                    onUnavailableAction(viewModel.phoneError ?? "필수 정보를 입력해 주세요.")
                    return
                }
                onSave(address)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}

private struct AddressEditorField: View {
    var title: String?
    var placeholder = ""
    @Binding var text: String
    var isDisabled = false
    var isFocused = false
    var error: String?

    init(
        title: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        isDisabled: Bool = false,
        isFocused: Bool = false,
        error: String? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        _text = text
        self.isDisabled = isDisabled
        self.isFocused = isFocused
        self.error = error
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(EUMColor.text3SwiftUI))
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text1SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(isDisabled ? EUMColor.surfaceSwiftUI : EUMColor.backgroundSwiftUI)
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                }
                .keyboardType(title == "휴대폰 번호" ? .phonePad : .default)
                .disabled(isDisabled)
                .accessibilityLabel(title ?? placeholder)
            if let error {
                HStack(spacing: 4) {
                    Image("AddressEditorAlert")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    Text(error)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                }
            }
        }
    }

    private var borderColor: Color {
        if error != nil { return EUMColor.dangerSwiftUI }
        if isDisabled { return EUMColor.lineSwiftUI }
        return isFocused ? EUMColor.text1SwiftUI : EUMColor.lineControlSwiftUI
    }

    private var borderWidth: CGFloat { error != nil || isFocused ? 1.5 : 1 }
}

struct AddressEditorViewPreview: PreviewProvider {
    static var previews: some View {
        AddressEditorView(address: nil, onBack: {}, onSave: { _ in }, onUnavailableAction: { _ in })
    }
}
