import SwiftUI

struct ContactInquiryDetailView: View {
    @StateObject private var viewModel: ContactInquiryDetailViewModel

    let onBack: () -> Void
    let onDownload: (String) -> Void

    init(inquiry: ContactInquiryRecord, onBack: @escaping () -> Void, onDownload: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: ContactInquiryDetailViewModel(inquiry: inquiry))
        self.onBack = onBack
        self.onDownload = onDownload
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    inquiryHeader
                    inquiryCard
                    if let answer = viewModel.inquiry.answer {
                        answerCard(answer: answer)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("문의 상세")
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
                .accessibilityLabel("1:1 문의 내역으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var inquiryHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.inquiry.status.rawValue)
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 4))
            Text(viewModel.inquiry.title)
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(viewModel.inquiry.date) · \(viewModel.inquiry.category)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var inquiryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            detailRow(title: "문의 유형", value: viewModel.inquiry.category)
            detailRow(title: "관련 주문", value: viewModel.inquiry.relatedOrderNumber)
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            Text(viewModel.inquiry.content)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            if let attachmentName = viewModel.inquiry.attachmentName {
                attachmentRow(fileName: attachmentName)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func answerCard(answer: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("답변")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 8)
                Text(viewModel.inquiry.answerDate ?? "")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            Text(answer)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func attachmentRow(fileName: String) -> some View {
        Button {
            onDownload(fileName)
        } label: {
            HStack(spacing: 8) {
                Image("QuoteDetailAttachment")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)
                Text(fileName)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("QuoteDetailDownload")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(12)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("첨부 파일 \(fileName) 다운로드")
    }
}
