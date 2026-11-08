import SwiftUI

struct UsageGuideView: View {
    let onBack: () -> Void
    let onCustomerCenterTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    documentHeader
                    contentsCard
                    sectionList
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
            Text("이용안내")
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
            HStack {
                Text("최종 수정 \(UsageGuideDocument.lastUpdatedDate)")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Spacer(minLength: 0)
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
            Text("\(UsageGuideDocument.sections.count)개 항목")
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

    private var sectionList: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(UsageGuideDocument.sections) { section in
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.title)
                            .font(EUMTypography.labelLarge)
                            .tracking(-0.16)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(UsageGuideDocument.body)
                            .font(EUMTypography.bodyMedium)
                            .tracking(-0.075)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                            .lineSpacing(6)
                            .padding(.bottom, 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if section.includesSampleItems {
                        VStack(alignment: .leading, spacing: 8) {
                            sampleItem("① \(UsageGuideDocument.itemBody)")
                            sampleItem("② \(UsageGuideDocument.itemBody)")
                        }
                    }

                    if !section.steps.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(section.steps) { step in
                                stepRow(step)
                            }
                        }
                    }

                    if section.showsCustomerCenterButton {
                        EUMButton(
                            title: "고객센터 가기",
                            kind: .secondary,
                            size: .medium,
                            action: onCustomerCenterTap
                        )
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

    private func stepRow(_ step: UsageGuideStep) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step.number)")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .frame(width: 24, height: 24)
                .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(EUMTypography.captionMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)

                Text(step.description)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
