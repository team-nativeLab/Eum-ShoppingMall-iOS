import SwiftUI

struct TermsView: View {
    let onBack: () -> Void
    let onPreviousTerms: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    documentHeader
                    contentsCard
                    articleGroups
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
            Text("이용약관")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("뒤로 가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var documentHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Text("시행일 \(TermsDocument.effectiveDate)")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineLimit(1)

                Spacer(minLength: 0)

                Button(action: onPreviousTerms) {
                    HStack(spacing: 6) {
                        Text("이전 약관 보기")
                            .font(EUMTypography.labelMedium)
                            .tracking(-0.07)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        Image("TermsVersionChevron")
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(EUMColor.backgroundSwiftUI)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }

            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
        }
        .padding(.bottom, 20)
    }

    private var contentsCard: some View {
        HStack(spacing: 8) {
            Text("목차")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            Spacer(minLength: 0)

            Text("\(TermsDocument.articleCount)개 조항")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)

            Image("TermsContentsChevron")
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var articleGroups: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(TermsDocument.chapters) { chapter in
                VStack(alignment: .leading, spacing: 24) {
                    Text(chapter.title)
                        .font(EUMTypography.heading3)
                        .tracking(-0.27)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .padding(.top, 8)

                    ForEach(chapter.articles) { article in
                        articleView(article)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 24) {
                Text("부칙")
                    .font(EUMTypography.heading3)
                    .tracking(-0.27)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .padding(.top, 8)

                Text(TermsDocument.addendum)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
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
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            if article.includesSampleItems {
                VStack(alignment: .leading, spacing: 8) {
                    Text("① \(TermsDocument.itemBody)")
                    Text("② \(TermsDocument.itemBody)")
                }
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
