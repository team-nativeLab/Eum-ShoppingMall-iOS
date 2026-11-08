import SwiftUI

struct QuoteDetailView: View {
    @StateObject private var viewModel: QuoteDetailViewModel

    let onBack: () -> Void
    let onDownload: (String) -> Void
    let onContact: () -> Void
    let onRequote: () -> Void

    init(
        inquiry: QuoteInquiryRecord,
        onBack: @escaping () -> Void,
        onDownload: @escaping (String) -> Void,
        onContact: @escaping () -> Void,
        onRequote: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: QuoteDetailViewModel(inquiry: inquiry))
        self.onBack = onBack
        self.onDownload = onDownload
        self.onContact = onContact
        self.onRequote = onRequote
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    titleGroup
                    progressCard
                    quoteResponseCard
                    requesterCard
                    productsCard
                    requestCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("견적 문의 상세")
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
                .accessibilityLabel("견적 문의 내역으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var titleGroup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.inquiry.status.rawValue)
                .font(.custom("NotoSansKR-Medium", size: 11))
                .foregroundStyle(EUMColor.text2SwiftUI)
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(EUMColor.surfaceSecondarySwiftUI, in: RoundedRectangle(cornerRadius: 4))
            Text(viewModel.inquiry.title)
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(viewModel.inquiry.date) · 문의번호 \(viewModel.inquiry.inquiryNumber)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var progressCard: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let trackWidth = max(geometry.size.width - 64, 0)
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(EUMColor.lineStrongSwiftUI)
                        .frame(width: trackWidth, height: 2)
                        .offset(x: 32, y: 9)
                    Rectangle()
                        .fill(EUMColor.text1SwiftUI)
                        .frame(width: trackWidth * CGFloat(viewModel.currentStepIndex) / 3, height: 2)
                        .offset(x: 32, y: 9)
                }
            }
            .frame(height: 40)
            .overlay {
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.stepTitles.enumerated()), id: \.offset) { index, title in
                        progressStep(title: title, index: index)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }

    private func progressStep(title: String, index: Int) -> some View {
        VStack(spacing: 6) {
            ZStack {
                if index <= viewModel.currentStepIndex {
                    Circle().fill(EUMColor.text1SwiftUI)
                    if index < viewModel.currentStepIndex {
                        Image("QuoteDetailStepCheck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                    }
                } else {
                    Circle()
                        .fill(EUMColor.backgroundSwiftUI)
                        .overlay(Circle().stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                }
            }
            .frame(width: 20, height: 20)
            Text(title)
                .font(.custom("NotoSansKR-Medium", size: 11))
                .foregroundStyle(index <= viewModel.currentStepIndex ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title)\(index == viewModel.currentStepIndex ? ", 현재 단계" : "")")
    }

    private var quoteResponseCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("견적 답변")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text(viewModel.response)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            HStack(alignment: .center) {
                Text("견적 금액")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 8)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(viewModel.amount)
                        .font(.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("VAT 별도")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
            }
            detailRow(title: "유효기간", value: viewModel.validity)
            detailRow(title: "담당자", value: viewModel.manager)
            attachmentRow(fileName: viewModel.quoteFileName)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var requesterCard: some View {
        detailCard(title: "문의자 정보") {
            detailRow(title: "회사명", value: viewModel.company)
            detailRow(title: "담당자", value: "홍길동")
            detailRow(title: "연락처", value: viewModel.contact)
            detailRow(title: "이메일", value: viewModel.email)
        }
    }

    private var productsCard: some View {
        detailCard(title: "요청 품목") {
            ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
                if index > 0 {
                    Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                }
                HStack(spacing: 12) {
                    Image("ProductPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(EUMColor.lineStrongSwiftUI)
                        .frame(width: 48, height: 48)
                        .background {
                            LinearGradient(
                                colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .accessibilityHidden(true)
                    Text(product.name)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(product.quantity)개")
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
            }
        }
    }

    private var requestCard: some View {
        detailCard(title: "요청 사항") {
            detailRow(title: "납품 희망일", value: viewModel.desiredDate)
            detailRow(title: "납품지", value: viewModel.deliveryAddress)
            detailRow(title: "내용", value: viewModel.requestDetails)
            attachmentRow(fileName: viewModel.requestFileName)
        }
    }

    private func detailCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(width: 88, alignment: .leading)
            Text(value)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func attachmentRow(fileName: String) -> some View {
        Button {
            onDownload(fileName)
        } label: {
            HStack(spacing: 8) {
                Image("QuoteDetailAttachment")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(fileName)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("QuoteDetailDownload")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(12)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(fileName) 다운로드")
    }

    private var bottomActions: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            HStack(spacing: 8) {
                EUMButton(title: "담당자에게 연락", kind: .primary, size: .medium, action: onContact)
                EUMButton(title: "재견적 요청", kind: .secondary, size: .medium, action: onRequote)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
