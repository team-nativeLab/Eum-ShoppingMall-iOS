import SwiftUI
import UIKit

struct CheckoutPaymentSectionHeading: View {
    let title: String

    var body: some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .frame(height: 40, alignment: .center)
            .accessibilityAddTraits(.isHeader)
    }
}

struct CheckoutPaymentMethodButton: View {
    let method: CheckoutPaymentMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(method.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(isSelected ? EUMColor.text1SwiftUI : EUMColor.lineStrongSwiftUI, lineWidth: isSelected ? 1.5 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct CheckoutTaxInvoiceBusinessInfo: View {
    @ObservedObject var viewModel: CheckoutPaymentViewModel

    var body: some View {
        Group {
            if viewModel.isEnteringTaxInvoiceInfo {
                taxInvoiceEntry
            } else {
                savedBusinessInfo
            }
        }
    }

    private var savedBusinessInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("사업자 정보")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                Button("변경", action: viewModel.startTaxInvoiceInfoEntry)
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityHint("세금계산서 발행용 사업자 정보를 직접 입력합니다")
            }
            invoiceInfoRow(title: "사업자등록번호", value: "000-00-00000")
            invoiceInfoRow(title: "상호", value: "회사명")
            invoiceInfoRow(title: "대표자명", value: "홍길동")
            invoiceInfoRow(title: "수신 이메일", value: "example@email.com")
            Text("회원 정보에 등록된 사업자 정보로 발행합니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var taxInvoiceEntry: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("세금계산서 발행 정보")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
            CheckoutTaxInvoiceInputField(
                title: "사업자등록번호 *",
                placeholder: "숫자 10자리",
                text: Binding(
                    get: { viewModel.businessRegistrationNumber },
                    set: viewModel.updateBusinessRegistrationNumber
                ),
                keyboardType: .numberPad
            )
            CheckoutTaxInvoiceInputField(
                title: "상호 *",
                placeholder: "상호를 입력해 주세요",
                text: $viewModel.taxInvoiceCompanyName
            )
            CheckoutTaxInvoiceInputField(
                title: "대표자명 *",
                placeholder: "대표자명을 입력해 주세요",
                text: $viewModel.taxInvoiceRepresentativeName
            )
            CheckoutTaxInvoiceInputField(
                title: "수신 이메일 *",
                placeholder: "이메일을 입력해 주세요",
                text: $viewModel.taxInvoiceEmail,
                keyboardType: .emailAddress
            )
            Text("세금계산서는 결제 완료 후 0일 이내 발행됩니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private func invoiceInfoRow(title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(title).foregroundStyle(EUMColor.text3SwiftUI).frame(width: 96, alignment: .leading)
            Text(value).foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
        }
        .font(EUMTypography.captionRegular)
        .accessibilityElement(children: .combine)
    }
}

private struct CheckoutTaxInvoiceInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(EUMColor.text3SwiftUI))
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 10)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(EUMColor.lineControlSwiftUI, lineWidth: 1)
                }
                .accessibilityLabel(title)
        }
    }
}

struct CheckoutReceiptOptionButton: View {
    let option: CheckoutReceiptOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI, lineWidth: isSelected ? 1.5 : 1)
                        .frame(width: 18, height: 18)
                    if isSelected {
                        Circle()
                            .fill(EUMColor.text1SwiftUI)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(option.rawValue)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
