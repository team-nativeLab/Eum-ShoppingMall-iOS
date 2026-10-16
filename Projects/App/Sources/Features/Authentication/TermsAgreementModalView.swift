import SwiftUI

struct TermsAgreementModalView: View {
    let onClose: () -> Void
    let onAgree: () -> Void

    private let visibleArticles = Array(TermsDocument.chapters[0].articles.prefix(4))

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("시행일 \(TermsDocument.effectiveDate)")
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.text2SwiftUI)

                    VStack(alignment: .leading, spacing: 24) {
                        Text(TermsDocument.chapters[0].title)
                            .font(EUMTypography.heading3)
                            .tracking(-0.27)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .padding(.top, 8)

                        ForEach(visibleArticles) { article in
                            articleView(article)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            bottomAction
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .accessibilityAddTraits(.isModal)
    }

    private var topBar: some View {
        ZStack {
            Text("이용약관")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("이용약관 닫기")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private func articleView(_ article: TermsArticle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(article.title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)

            Text(TermsDocument.articleBody)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

            if article.includesSampleItems {
                VStack(alignment: .leading, spacing: 8) {
                    Text("① \(TermsDocument.itemBody)")
                    Text("② \(TermsDocument.itemBody)")
                }
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var bottomAction: some View {
        EUMButton(title: "동의하기", size: .large, action: onAgree)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 34)
            .background(EUMColor.backgroundSwiftUI)
            .overlay(alignment: .top) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            }
    }
}
