import SwiftUI

struct QuoteHistoryView: View {
    @StateObject private var viewModel = QuoteHistoryViewModel()

    let onBack: () -> Void
    let onNewInquiry: () -> Void
    let onDocument: (QuoteInquiryRecord) -> Void
    let onOpenDetail: (QuoteInquiryRecord) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            if viewModel.inquiries.isEmpty {
                emptyState.padding(20).frame(maxHeight: .infinity)
            } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    statusFilters
                    inquiryList
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            }
            newInquiryButton
        }
        .background((viewModel.inquiries.isEmpty ? AccountEmptyState.background : EUMColor.backgroundSwiftUI).ignoresSafeArea())
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "견적 문의 내역",
            backAccessibilityLabel: "이전 화면으로 돌아가기",
            backAccessibilityIdentifier: "quote-history-back",
            onBack: onBack
        ) {
            EmptyView()
        }
    }

    private var statusFilters: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(QuoteInquiryStatus.allCases) { status in
                    filterButton(status)
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.trailing, -20)
    }

    private func filterButton(_ status: QuoteInquiryStatus) -> some View {
        let isSelected = viewModel.selectedStatus == status
        return Button {
            viewModel.selectedStatus = status
        } label: {
            Text(status.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
                .overlay(Capsule().stroke(isSelected ? .clear : EUMColor.lineStrongSwiftUI, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var inquiryList: some View {
        if viewModel.visibleInquiries.isEmpty {
            emptyState
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.visibleInquiries) { inquiry in
                    QuoteInquiryCard(inquiry: inquiry, onDocument: onDocument, onOpenDetail: onOpenDetail)
                }
            }
        }
    }

    private var emptyState: some View {
        AccountEmptyState(
            title: "견적 문의 내역이 없습니다", message: "견적을 문의하면 진행 상태와\n답변을 확인할 수 있어요."
        )
    }

    private var newInquiryButton: some View {
        Button(action: onNewInquiry) {
            Text("새 견적 문의")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.medium))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 32)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }
}

private struct QuoteInquiryCard: View {
    let inquiry: QuoteInquiryRecord
    let onDocument: (QuoteInquiryRecord) -> Void
    let onOpenDetail: (QuoteInquiryRecord) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            titleAndSummary
            if inquiry.showsDocument {
                documentNotice
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    @ViewBuilder
    private var titleAndSummary: some View {
        if inquiry.status == .quoteSent {
            Button {
                onOpenDetail(inquiry)
            } label: {
                titleAndSummaryContent
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(inquiry.title) 상세 보기")
        } else {
            titleAndSummaryContent
        }
    }

    private var titleAndSummaryContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(inquiry.title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text(inquiry.productSummary)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text(inquiry.date)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text("문의번호 \(inquiry.inquiryNumber)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            statusBadge
        }
    }

    private var statusBadge: some View {
        let status = inquiry.status
        return Text(status.rawValue)
            .font(.custom("NotoSansKR-Medium", size: 11))
            .foregroundStyle(statusForeground(status))
            .padding(.horizontal, 6)
            .frame(height: 20)
            .background(statusBackground(status), in: RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(status == .received ? EUMColor.lineStrongSwiftUI : .clear, lineWidth: 1))
    }

    private var documentNotice: some View {
        HStack(spacing: 8) {
            Image("QuoteHistoryFile")
                .resizable()
                .frame(width: 16, height: 16)
            Text("견적서가 도착했습니다")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button { onDocument(inquiry) } label: {
                Text("견적서 보기")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
    }

    private func statusForeground(_ status: QuoteInquiryStatus) -> Color {
        switch status {
        case .completed: EUMColor.inverseSwiftUI
        case .canceled: EUMColor.text3SwiftUI
        default: EUMColor.text2SwiftUI
        }
    }

    private func statusBackground(_ status: QuoteInquiryStatus) -> Color {
        switch status {
        case .quoteSent, .consulting: EUMColor.surfaceSecondarySwiftUI
        case .completed: EUMColor.text1SwiftUI
        default: EUMColor.backgroundSwiftUI
        }
    }
}
