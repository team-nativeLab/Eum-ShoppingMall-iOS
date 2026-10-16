import SwiftUI
import UniformTypeIdentifiers

struct BusinessSignUpInformationView: View {
    @ObservedObject var viewModel: SignUpViewModel
    var onMessage: (String) -> Void
    @State private var isCertificateImporterPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("사업자 정보")
                .font(EUMTypography.labelLarge)
                .tracking(-0.08)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.top, 12)

            businessRegistrationRow
            EUMTextField(title: "상호 *", placeholder: "상호를 입력해 주세요", text: $viewModel.companyName)
            EUMTextField(title: "대표자명 *", placeholder: "대표자명을 입력해 주세요", text: $viewModel.representativeName)
            EUMTextField(title: "업태 / 종목", placeholder: "업태와 종목을 입력해 주세요", text: $viewModel.businessType)
            taxInvoiceEmailField
            sameEmailToggle
            certificateUpload
            businessNotice
        }
    }

    private var businessRegistrationRow: some View {
        HStack(alignment: .bottom, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("사업자등록번호 *")
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                TextField("000-00-00000", text: $viewModel.businessRegistrationNumber)
                    .font(EUMTypography.bodyMedium)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                    .accessibilityLabel("사업자등록번호")
                if viewModel.isBusinessRegistrationVerified {
                    Label("확인되었습니다.", systemImage: "checkmark.circle")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
            }
            EUMButton(title: "확인", kind: .secondary, size: .medium) {
                let verified = viewModel.verifyBusinessRegistration()
                onMessage(verified ? "사업자등록번호를 확인했어요." : "사업자등록번호 10자리를 입력해 주세요.")
            }
            .frame(width: 60)
            .padding(.bottom, 24)
        }
    }

    private var taxInvoiceEmailField: some View {
        EUMTextField(
            title: "세금계산서 수신 이메일",
            placeholder: "example@email.com",
            text: $viewModel.taxInvoiceEmail,
            isDisabled: viewModel.taxInvoiceEmailMatchesAccount
        )
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }

    private var sameEmailToggle: some View {
        Button {
            viewModel.setTaxInvoiceEmailMatchesAccount(!viewModel.taxInvoiceEmailMatchesAccount)
        } label: {
            HStack(spacing: 8) {
                checkbox(isOn: viewModel.taxInvoiceEmailMatchesAccount)
                Text("계정 이메일과 같음")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("계정 이메일과 같음")
        .accessibilityValue(viewModel.taxInvoiceEmailMatchesAccount ? "켜짐" : "꺼짐")
    }

    private var certificateUpload: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사업자등록증 *")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Button {
                isCertificateImporterPresented = true
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: viewModel.registrationCertificateName == nil ? "square.and.arrow.up" : "checkmark.circle")
                        .font(.system(size: 20))
                    Text(viewModel.registrationCertificateName ?? "파일을 선택해 주세요")
                        .font(EUMTypography.bodySmall)
                        .lineLimit(1)
                    if viewModel.registrationCertificateName == nil {
                        Text("이미지 또는 PDF · 최대 00MB")
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                    }
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(EUMColor.lineControlSwiftUI, style: StrokeStyle(lineWidth: 1, dash: [4]))
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(viewModel.registrationCertificateName ?? "사업자등록증 파일 선택, 이미지 또는 PDF")
        }
        .fileImporter(
            isPresented: $isCertificateImporterPresented,
            allowedContentTypes: [.pdf, .image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case let .success(urls):
                viewModel.registrationCertificateName = urls.first?.lastPathComponent
            case .failure:
                onMessage("파일을 불러오지 못했어요. 다시 선택해 주세요.")
            }
        }
    }

    private var businessNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 16))
                .padding(.top, 2)
                .accessibilityHidden(true)
            Text("사업자 정보 확인 후 사업자 회원 혜택이 적용됩니다. 확인에는 영업일 기준 0일이 걸립니다.")
                .font(EUMTypography.bodySmall)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .foregroundStyle(EUMColor.text2SwiftUI)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .accessibilityElement(children: .combine)
    }

    private func checkbox(isOn: Bool) -> some View {
        RoundedRectangle(cornerRadius: EUMRadius.small)
            .fill(isOn ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
            .frame(width: 20, height: 20)
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .stroke(isOn ? EUMColor.text1SwiftUI : EUMColor.lineControlSwiftUI, lineWidth: 1.5)
            }
            .overlay {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                }
            }
            .accessibilityHidden(true)
    }
}
