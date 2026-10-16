import SwiftUI

struct TermsView: View {
    enum Version: Equatable {
        case current
        case previous
        case revisionScheduled
    }

    let version: Version
    let onBack: () -> Void
    let onPreviousVersionSelected: () -> Void

    @State private var isShowingVersionPicker = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    documentHeader
                    inlineNotice
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
        .overlay {
            if isShowingVersionPicker {
                ZStack(alignment: .bottom) {
                    Button {
                        isShowingVersionPicker = false
                    } label: {
                        EUMColor.text1SwiftUI.opacity(0.48)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("약관 버전 선택 닫기")

                    TermsVersionPickerView(
                        selectedVersion: version,
                        onDismiss: { isShowingVersionPicker = false },
                        onPreviousVersionSelected: {
                            isShowingVersionPicker = false
                            onPreviousVersionSelected()
                        }
                    )
                    .transition(.move(edge: .bottom))
                }
                .ignoresSafeArea()
                .transition(.opacity)
                .zIndex(2)
            }
        }
        .animation(.easeOut(duration: 0.2), value: isShowingVersionPicker)
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

                Button {
                    isShowingVersionPicker = true
                } label: {
                    HStack(spacing: 6) {
                        Text(versionButtonTitle)
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

    @ViewBuilder
    private var inlineNotice: some View {
        if version != .current {
            HStack(alignment: .top, spacing: 8) {
                Image("LoginInfo")
                    .frame(width: 16, height: 16)
                    .padding(.top, 2)
                    .accessibilityHidden(true)

                (
                    Text(noticePrefix)
                    + Text(noticeLinkLabel)
                        .font(.custom("NotoSansKR-Medium", size: 14, relativeTo: .callout))
                        .underline()
                )
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(3)
                .padding(.bottom, 3)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 12))
            .accessibilityElement(children: .combine)
        }
    }

    private var versionButtonTitle: String {
        switch version {
        case .current, .revisionScheduled:
            "이전 약관 보기"
        case .previous:
            "\(TermsDocument.effectiveDate) 시행"
        }
    }

    private var noticePrefix: String {
        switch version {
        case .current:
            ""
        case .previous:
            TermsDocument.previousVersionNoticePrefix
        case .revisionScheduled:
            TermsDocument.revisionScheduledNoticePrefix
        }
    }

    private var noticeLinkLabel: String {
        switch version {
        case .current:
            ""
        case .previous:
            TermsDocument.currentTermsLabel
        case .revisionScheduled:
            TermsDocument.revisionScheduledLabel
        }
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
                        .lineSpacing(4)
                        .padding(.bottom, 4)
                        .fixedSize(horizontal: false, vertical: true)
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
                    .lineSpacing(4)
                    .padding(.bottom, 4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)

                Text(TermsDocument.addendum)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineSpacing(6)
                    .padding(.bottom, 6)
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
                .lineSpacing(4)
                .padding(.bottom, 4)
                .fixedSize(horizontal: false, vertical: true)

            Text(TermsDocument.articleBody)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineSpacing(6)
                .padding(.bottom, 6)
                .fixedSize(horizontal: false, vertical: true)

            if article.includesSampleItems {
                VStack(alignment: .leading, spacing: 8) {
                    sampleItemText("① \(TermsDocument.itemBody)")
                    sampleItemText("② \(TermsDocument.itemBody)")
                }
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func sampleItemText(_ copy: String) -> some View {
        Text(copy)
            .lineSpacing(6)
            .padding(.bottom, 6)
            .fixedSize(horizontal: false, vertical: true)
    }
}
