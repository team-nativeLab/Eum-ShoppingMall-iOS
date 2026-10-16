import SwiftUI

struct PrivacyPolicyView: View {
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    documentHeader
                    contentsCard
                    sections
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
            Text("개인정보처리방침")
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
                Text("시행일 \(PrivacyPolicyDocument.effectiveDate)")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineLimit(1)

                Spacer(minLength: 0)

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
                .accessibilityElement(children: .combine)
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

            Text("\(PrivacyPolicyDocument.sections.count)개 항목")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)

            Image("TermsContentsChevron")
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }

    private var sections: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(PrivacyPolicyDocument.sections) { section in
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.title)
                            .font(EUMTypography.labelLarge)
                            .tracking(-0.16)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(PrivacyPolicyDocument.articleBody)
                            .font(EUMTypography.bodyMedium)
                            .tracking(-0.075)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                            .lineSpacing(6)
                            .padding(.bottom, 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if section.includesSampleItems {
                        VStack(alignment: .leading, spacing: 8) {
                            sampleItem("① \(PrivacyPolicyDocument.itemBody)")
                            sampleItem("② \(PrivacyPolicyDocument.itemBody)")
                        }
                    }

                    if !section.detailRows.isEmpty {
                        detailCard(for: section)
                    }
                }
            }
        }
    }

    private func sampleItem(_ text: String) -> some View {
        Text(text)
            .font(EUMTypography.bodyMedium)
            .tracking(-0.075)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .lineSpacing(6)
            .padding(.bottom, 6)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func detailCard(for section: PrivacyPolicySection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(section.detailRows) { row in
                HStack(alignment: .top, spacing: 12) {
                    Text(row.label)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(width: 88, alignment: .leading)

                    Text(row.value)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            section.usesSubtleCard ? EUMColor.backgroundSubtleSwiftUI : EUMColor.backgroundSwiftUI,
            in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay {
            if !section.usesSubtleCard {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
            }
        }
    }
}
