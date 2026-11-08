import SwiftUI

struct QuoteInquiryFieldsView: View {
    @ObservedObject var viewModel: QuoteInquiryViewModel
    @Binding var isDatePickerPresented: Bool
    @Binding var isFileImporterPresented: Bool
    let onMessage: (String) -> Void
    let onShowPrivacyConsent: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("문의 유형 *")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            inquiryTypePicker
            VStack(spacing: 20) {
                memberInfoNotice
                EUMTextField(title: "회사명 *", placeholder: "회사명", text: $viewModel.company)
                EUMTextField(title: "담당자 *", placeholder: "담당자 이름", text: $viewModel.contactName)
                    .textContentType(.name)
                EUMTextField(title: "연락처 *", placeholder: "010-0000-0000", text: $viewModel.phoneNumber)
                    .keyboardType(.phonePad)
                EUMTextField(title: "이메일 *", placeholder: "example@email.com", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                deliveryDateField
                EUMTextField(title: "납품 지역", placeholder: "예: 경기도 00시", text: $viewModel.deliveryArea)
                detailsField
                QuoteAttachmentField(viewModel: viewModel, isFileImporterPresented: $isFileImporterPresented)
                QuotePrivacyAgreement(viewModel: viewModel, onShowPrivacyConsent: onShowPrivacyConsent)
            }
        }
    }

    private var inquiryTypePicker: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
            alignment: .leading,
            spacing: 12
        ) {
            ForEach(QuoteInquiryType.allCases) { type in
                Button {
                    viewModel.inquiryType = type
                } label: {
                    HStack(spacing: 8) {
                        Circle()
                            .strokeBorder(
                                viewModel.inquiryType == type ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI,
                                lineWidth: 1.5
                            )
                            .frame(width: 20, height: 20)
                            .overlay {
                                if viewModel.inquiryType == type {
                                    Circle().fill(EUMColor.text1SwiftUI).frame(width: 10, height: 10)
                                }
                            }
                        Text(type.rawValue)
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .fixedSize()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(type.rawValue)
                .accessibilityAddTraits(viewModel.inquiryType == type ? .isSelected : [])
            }
        }
    }

    private var memberInfoNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("LoginInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
                .accessibilityHidden(true)
            Text("회원 정보로 미리 채웠습니다.\n필요하면 수정해 주세요.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var deliveryDateField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("희망 납기")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Button {
                isDatePickerPresented = true
            } label: {
                HStack {
                    Text(viewModel.deliveryDate.isEmpty ? "0000.00.00" : viewModel.deliveryDate)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(viewModel.deliveryDate.isEmpty ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.text3SwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("희망 납기 선택")
        }
    }

    private var detailsField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("상세 내용")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            TextEditor(text: Binding(
                get: { viewModel.details },
                set: { viewModel.details = String($0.prefix(1_000)) }
            ))
            .font(EUMTypography.bodyMedium)
            .scrollContentBackground(.hidden)
            .frame(height: 96)
            .overlay(alignment: .topLeading) {
                if viewModel.details.isEmpty {
                    Text("제작 사양, 로고 인쇄 여부 등\n상세 내용을 입력해 주세요")
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.textDisabledSwiftUI)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.text3SwiftUI, lineWidth: 1))
            .accessibilityLabel("상세 내용")
            Text("\(viewModel.details.count)/1,000")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private struct QuoteAttachmentField: View {
    @ObservedObject var viewModel: QuoteInquiryViewModel
    @Binding var isFileImporterPresented: Bool

    var body: some View {
        Button {
            isFileImporterPresented = true
        } label: {
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image("QuotePaperclip")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("파일 첨부 (도면·이미지)")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
                Text(viewModel.attachmentNames.isEmpty ? "허용 형식·용량 안내 문구" : viewModel.attachmentNames.joined(separator: ", "))
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 96)
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.large)
                    .stroke(EUMColor.text3SwiftUI, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("도면 또는 이미지 파일 첨부")
    }
}

private struct QuotePrivacyAgreement: View {
    @ObservedObject var viewModel: QuoteInquiryViewModel
    let onShowPrivacyConsent: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: viewModel.togglePrivacyAgreement) {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .fill(viewModel.agreedToPrivacy ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                    .frame(width: 20, height: 20)
                    .overlay {
                        RoundedRectangle(cornerRadius: EUMRadius.small)
                            .stroke(
                                viewModel.agreedToPrivacy ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI,
                                lineWidth: 1.5
                            )
                    }
                    .overlay {
                        if viewModel.agreedToPrivacy {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(EUMColor.inverseSwiftUI)
                        }
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("개인정보 수집 및 이용 동의")
            .accessibilityValue(viewModel.agreedToPrivacy ? "동의" : "동의 안 함")
            Text("[필수] 개인정보 수집·이용 동의")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
            Button("보기", action: onShowPrivacyConsent)
            .font(EUMTypography.captionRegular)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .underline()
        }
    }
}
