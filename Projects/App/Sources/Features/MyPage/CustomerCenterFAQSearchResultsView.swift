import SwiftUI

struct CustomerCenterFAQSearchResultsView: View {
    let viewModel: CustomerCenterFAQSearchViewModel
    let onBack: () -> Void
    let onCall: () -> Void
    let onContact: () -> Void

    init(
        viewModel: CustomerCenterFAQSearchViewModel = CustomerCenterFAQSearchViewModel(),
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
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    CustomerCenterContactCard(
                        viewModel: CustomerCenterViewModel(),
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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("고객센터")
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
                .accessibilityLabel("고객센터로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("자주 묻는 질문")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            searchBar

            Text(viewModel.resultCountTitle)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)

            faqList
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image("DesignSearch")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .accessibilityHidden(true)

            Text(viewModel.query)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel("검색어: \(viewModel.query)")

            Button(action: onBack) {
                Image("SearchClear")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("검색 초기화")
        }
        .padding(.leading, 16)
        .padding(.trailing, 4)
        .frame(height: 44)
        .background(EUMColor.surfaceSwiftUI, in: Capsule())
    }

    private var faqList: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.results) { result in
                faqRow(result)
            }
        }
    }

    private func faqRow(_ result: CustomerCenterFAQSearchResult) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Q")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 32, alignment: .leading)

                highlightedQuestion(result.question)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Image("ProductOptionChevron")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 24)

            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    private func highlightedQuestion(_ question: String) -> some View {
        var attributedQuestion = AttributedString(question)
        attributedQuestion.font = EUMTypography.labelLarge
        attributedQuestion.foregroundColor = EUMColor.text1SwiftUI

        if let match = question.range(of: viewModel.query, options: .caseInsensitive),
           let attributedRange = Range(match, in: attributedQuestion) {
            attributedQuestion[attributedRange].font = .custom("NotoSansKR-Bold", size: 16, relativeTo: .headline)
        }

        return Text(attributedQuestion).tracking(-0.16).lineSpacing(2)
    }
}
