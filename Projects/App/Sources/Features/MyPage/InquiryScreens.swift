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
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && (context != .contact || !inquiryType.isEmpty)
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

        return ContactInquiryRecord(
            id: id,
            date: date ?? Self.currentDate,
            category: resolvedType,
            status: .pending,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
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
            EUMBackTopBar(
                title: viewModel.context.title,
                backAccessibilityLabel: "뒤로 가기",
                backAccessibilityIdentifier: "inquiry-compose-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44)
            }

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

                    EUMTextField(title: "제목", placeholder: "문의 제목을 입력해 주세요", text: $viewModel.title)
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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                EUMButton(title: "문의 등록", size: .large) {
                    onSubmit(viewModel.makeRecord())
                }
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(EUMColor.backgroundSwiftUI)
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
            TextEditor(text: $viewModel.content)
                .font(EUMTypography.bodyMedium)
                .scrollContentBackground(.hidden)
                .padding(8)
                .frame(height: 150)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
                .accessibilityLabel("문의 내용")
                .accessibilityIdentifier("inquiry-content")
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
        Toggle("비밀글로 문의하기", isOn: $viewModel.isPrivate)
            .font(EUMTypography.bodySmall)
            .tint(EUMColor.text1SwiftUI)
            .padding(.horizontal, 12)
            .frame(height: 50)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
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
            EUMBackTopBar(
                title: "문의가 등록됐어요",
                backAccessibilityLabel: "뒤로 가기",
                backAccessibilityIdentifier: "inquiry-complete-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44)
            }

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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            EUMButton(title: "문의 내역 보기", size: .large, action: onViewInquiries)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(EUMColor.backgroundSwiftUI)
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

struct ProductReviewsView: View {
    let onBack: () -> Void

    private let reviews = [
        "튼튼하고 착용감이 편해요. 배송도 빨랐습니다.",
        "현장 작업에 잘 맞고 마감이 좋습니다."
    ]

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "상품 리뷰",
                backAccessibilityLabel: "상품 상세로 돌아가기",
                backAccessibilityIdentifier: "product-reviews-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("평점 4.8 · 리뷰 128개")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                    VStack(alignment: .leading, spacing: 8) {
                        sectionTitle("별점")
                        HStack(spacing: 8) {
                            HStack(spacing: 7) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image("ProductReviewStar")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                }
                            }
                            Text("4.8")
                                .font(EUMTypography.bodySmall)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                        }
                        .padding(.horizontal, 13)
                        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                        .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
                    }

                    ForEach(Array(reviews.enumerated()), id: \.offset) { _, review in
                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("리뷰")
                            Text(review)
                                .font(EUMTypography.bodyMedium)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                                .padding(13)
                                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelMedium)
            .foregroundStyle(EUMColor.text1SwiftUI)
    }
}
