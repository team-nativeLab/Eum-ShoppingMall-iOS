import Combine
import Foundation
import PhotosUI
import SwiftUI
import _PhotosUI_SwiftUI

enum InquiryComposeContext: Equatable {
    case contact
    case product(name: String)

    var title: String {
        switch self {
        case .contact: "1:1 문의하기"
        case .product: "상품 문의하기"
        }
    }

    var description: String {
        switch self {
        case .contact: "문의 내용을 남겨 주시면 확인 후 답변드릴게요."
        case let .product(name): "\(name)에 대해 궁금한 점을 남겨 주세요."
        }
    }
}

@MainActor
final class InquiryComposeViewModel: ObservableObject {
    @Published var inquiryType = ""
    @Published var title = ""
    @Published var content = ""
    @Published var isPrivate = false
    @Published var selectedPhotos: [PhotosPickerItem] = []

    let context: InquiryComposeContext
    let inquiryTypes = ["주문·배송", "상품", "결제", "기타"]

    init(context: InquiryComposeContext) {
        self.context = context
        if case .product = context {
            inquiryType = "상품"
        }
    }

    var canSubmit: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && (context != .contact || (!title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !inquiryType.isEmpty))
    }

    var photoSelectionDescription: String {
        selectedPhotos.isEmpty ? "선택 · 최대 5장" : "사진 \(selectedPhotos.count)장 선택 · 최대 5장"
    }

    func makeRecord(id: String = UUID().uuidString, date: String? = nil) -> ContactInquiryRecord {
        let resolvedType: String
        if case .product = context {
            resolvedType = "상품"
        } else {
            resolvedType = inquiryType
        }

        let resolvedTitle: String
        switch context {
        case .contact:
            resolvedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        case let .product(name):
            resolvedTitle = name
        }

        return ContactInquiryRecord(
            id: id,
            date: date ?? Self.currentDate,
            category: resolvedType,
            status: .pending,
            title: resolvedTitle,
            summary: String(content.trimmingCharacters(in: .whitespacesAndNewlines).prefix(80)),
            relatedOrderNumber: "0000000000",
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            attachmentName: selectedPhotos.isEmpty ? nil : "사진 \(selectedPhotos.count)장",
            answerDate: nil,
            answer: nil,
            isPrivate: isPrivate
        )
    }

    private static var currentDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
}

struct InquiryComposeView: View {
    @StateObject private var viewModel: InquiryComposeViewModel

    let onBack: () -> Void
    let onSubmit: (ContactInquiryRecord) -> Void

    init(context: InquiryComposeContext, onBack: @escaping () -> Void, onSubmit: @escaping (ContactInquiryRecord) -> Void) {
        _viewModel = StateObject(wrappedValue: InquiryComposeViewModel(context: context))
        self.onBack = onBack
        self.onSubmit = onSubmit
    }

    var body: some View {
        VStack(spacing: 0) {
            InquiryScreenTopBar(
                title: viewModel.context.title,
                backAccessibilityLabel: "뒤로 가기",
                backAccessibilityIdentifier: "inquiry-compose-back",
                onBack: onBack
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.context.description)
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)

                    if viewModel.context == .contact {
                        inquiryTypeField
                    } else if case let .product(name) = viewModel.context {
                        labeledField(title: "상품") {
                            Text(name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    if viewModel.context == .contact {
                        EUMTextField(title: "제목", placeholder: "문의 제목을 입력해 주세요", text: $viewModel.title)
                    }
                    contentField

                    if case .contact = viewModel.context {
                        photoField
                    } else {
                        privacySetting
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 28)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                Button { onSubmit(viewModel.makeRecord()) } label: {
                    Text("문의 등록")
                        .font(EUMTypography.labelLarge)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(InquiryPrimaryButtonStyle())
                .disabled(!viewModel.canSubmit)
                .accessibilityLabel("문의 등록")
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(EUMColor.backgroundSubtleSwiftUI)
        }
    }

    private var inquiryTypeField: some View {
        labeledField(title: "문의 유형") {
            Menu {
                ForEach(viewModel.inquiryTypes, id: \.self) { type in
                    Button(type) { viewModel.inquiryType = type }
                }
            } label: {
                HStack {
                    Text(viewModel.inquiryType.isEmpty ? "문의 유형을 선택해 주세요" : viewModel.inquiryType)
                        .foregroundStyle(viewModel.inquiryType.isEmpty ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("inquiry-type-picker")
        }
    }

    private var contentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("문의 내용")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            ZStack(alignment: .topLeading) {
                if viewModel.content.isEmpty {
                    Text(viewModel.context == .contact ? "문의 내용을 입력해 주세요" : "상품에 대해 궁금한 점을 입력해 주세요")
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .padding(.horizontal, 13)
                        .padding(.top, 16)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $viewModel.content)
                    .font(EUMTypography.bodyMedium)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .accessibilityLabel("문의 내용")
                    .accessibilityIdentifier("inquiry-content")
            }
            .frame(height: 150)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }

    private var photoField: some View {
        let selectionDescription = viewModel.photoSelectionDescription
        return labeledField(title: "사진 첨부") {
            PhotosPicker(selection: $viewModel.selectedPhotos, maxSelectionCount: 5, matching: .images) {
                Text(selectionDescription)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("inquiry-photo-picker")
        }
    }

    private var privacySetting: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("공개 설정")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Button {
                viewModel.isPrivate.toggle()
            } label: {
                Text("비밀글로 문의하기")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("비밀글로 문의하기")
            .accessibilityValue(viewModel.isPrivate ? "켜짐" : "꺼짐")
            .accessibilityAddTraits(viewModel.isPrivate ? .isSelected : [])
            .padding(.horizontal, 13)
            .frame(height: 50)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }

    private func labeledField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            content()
                .font(EUMTypography.bodyMedium)
                .padding(.horizontal, 13)
                .frame(height: 50)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }
}

struct InquiryCompletionView: View {
    let onBack: () -> Void
    let onViewInquiries: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            InquiryScreenTopBar(
                title: "문의가 등록됐어요",
                backAccessibilityLabel: "뒤로 가기",
                backAccessibilityIdentifier: "inquiry-complete-back",
                onBack: onBack
            )

            VStack(alignment: .leading, spacing: 20) {
                Text("문의 내역에서 답변 상태를 확인할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                informationCard(title: "접수 상태", value: "답변 대기")
                informationCard(title: "안내", value: "등록한 문의는 마이페이지에서 확인할 수 있습니다.")
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button(action: onViewInquiries) {
                Text("문의 내역 보기")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(InquiryPrimaryButtonStyle())
            .accessibilityLabel("문의 내역 보기")
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(EUMColor.backgroundSubtleSwiftUI)
        }
    }

    private func informationCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text(value)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
        }
        .padding(13)
        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}

private struct InquiryScreenTopBar: View {
    let title: String
    let backAccessibilityLabel: String
    let backAccessibilityIdentifier: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image("ProductDetailBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 32, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(backAccessibilityLabel)
            .accessibilityIdentifier(backAccessibilityIdentifier)

            Text(title)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay(alignment: .bottom) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }
}

private struct InquiryPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.88 : 1)
    }
}
