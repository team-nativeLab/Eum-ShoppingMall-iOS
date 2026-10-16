import SwiftUI

struct CustomerCenterView: View {
    let viewModel: CustomerCenterViewModel
    let onBack: () -> Void
    let onCall: () -> Void
    let onContact: () -> Void
    @State private var isShowingFAQSearchResults = false

    init(
        viewModel: CustomerCenterViewModel = CustomerCenterViewModel(),
        onBack: @escaping () -> Void,
        onCall: @escaping () -> Void,
        onContact: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onBack = onBack
        self.onCall = onCall
        self.onContact = onContact
    }

    var body: some View {
        Group {
            if isShowingFAQSearchResults {
                CustomerCenterFAQSearchResultsView(
                    onBack: { isShowingFAQSearchResults = false },
                    onCall: onCall,
                    onContact: onContact
                )
            } else {
                VStack(spacing: 0) {
                    topBar
                    ScrollView {
                        VStack(alignment: .leading, spacing: 32) {
                            CustomerCenterContactCard(
                                viewModel: viewModel,
                                onCall: onCall,
                                onContact: onContact
                            )
                            faqSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "고객센터",
            backAccessibilityLabel: "마이페이지로 돌아가기",
            onBack: onBack
        ) {
            Color.clear
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)
        }
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("자주 묻는 질문")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            faqSearchBar

            categoryChips
            faqList
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories) { category in
                    categoryChip(category)
                }
            }
        }
        .scrollIndicators(.hidden)
        .accessibilityLabel("FAQ 카테고리")
    }

    private var faqSearchBar: some View {
        Button {
            isShowingFAQSearchResults = true
        } label: {
            HStack(spacing: 8) {
                Image("DesignSearch")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .accessibilityHidden(true)

                Text("궁금한 내용을 검색해 보세요")
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(EUMColor.surfaceSwiftUI, in: Capsule())
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("FAQ 검색")
        .accessibilityHint("배송 FAQ 검색 결과를 봅니다")
    }

    private func categoryChip(_ category: CustomerCenterFAQCategory) -> some View {
        let isSelected = category == .all
        return Text(category.rawValue)
            .font(EUMTypography.labelMedium)
            .tracking(-0.07)
            .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
            .overlay(Capsule().stroke(isSelected ? .clear : EUMColor.lineStrongSwiftUI, lineWidth: 1))
    }

    private var faqList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.faqs) { faq in
                faqRow(faq)
            }
        }
    }

    private func faqRow(_ faq: CustomerCenterFAQ) -> some View {
        let isExpanded = faq.id == viewModel.expandedFAQID

        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Q")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 32, alignment: .leading)

                Text(faq.question)
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Image(isExpanded ? "CustomerCenterChevronUp" : "ProductOptionChevron")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 24)

            if isExpanded, let answer = faq.answer {
                answerCard(answer)
                Spacer().frame(height: 24)
            }

            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    private func answerCard(_ answer: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text("A")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 32, alignment: .leading)

            Text(answer)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(1)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}
