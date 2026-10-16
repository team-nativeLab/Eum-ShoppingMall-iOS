import SwiftUI

struct CompanyIntroductionView: View {
    let viewModel: CompanyIntroductionViewModel
    let onBack: () -> Void
    let onOpenMap: () -> Void

    init(
        viewModel: CompanyIntroductionViewModel = CompanyIntroductionViewModel(),
        onBack: @escaping () -> Void,
        onOpenMap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onBack = onBack
        self.onOpenMap = onOpenMap
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 0) {
                    introduction
                    sectionNavigation
                    overviewSection
                    businessSection
                    historySection
                    certificationSection
                    partnersSection
                    locationSection
                }
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("회사소개")
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
                .accessibilityLabel("메뉴로 돌아가기")

                Spacer()
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 16) {
            GeometryReader { geometry in
                Image("CompanyIntroductionHero")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 219)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
            }
            .frame(height: 219)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 10) {
                overline("ABOUT US")

                Text(viewModel.heroTitle)
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)

                Text(viewModel.heroDescription)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 16)
        .padding(.bottom, 28)
    }

    private var sectionNavigation: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(viewModel.sectionNavigation.enumerated()), id: \.offset) { index, title in
                    CompanyIntroductionSectionChip(title: title, isSelected: index == 0)
                }
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .top) { divider }
        .overlay(alignment: .bottom) { divider }
        .accessibilityLabel("회사소개 섹션")
    }

    private var overviewSection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "OVERVIEW", title: viewModel.overviewTitle)

                Text(viewModel.overviewDescription)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var businessSection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "BUSINESS", title: "사업 분야")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(viewModel.businessAreas) { area in
                        CompanyIntroductionBusinessCard(area: area)
                    }
                }
            }
        }
    }

    private var historySection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "HISTORY", title: "연혁")

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.historyItems) { item in
                        CompanyIntroductionHistoryRow(item: item)
                    }
                }
            }
        }
    }

    private var certificationSection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "CERTIFICATION", title: "인증")

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.certifications) { certification in
                        HStack(spacing: 12) {
                            Text(certification.title)
                                .font(EUMTypography.bodySmall)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                                .frame(width: 68, alignment: .leading)

                            Text(certification.description)
                                .font(EUMTypography.labelMedium)
                                .tracking(-0.07)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
    }

    private var partnersSection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "PARTNERS", title: "파트너")

                HStack(spacing: 12) {
                    ForEach(Array(viewModel.partners.enumerated()), id: \.offset) { _, partner in
                        Text(partner)
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                    }
                }
                .accessibilityLabel("파트너 로고 임시 표시")
            }
        }
    }

    private var locationSection: some View {
        section {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader(eyebrow: "LOCATION", title: "오시는 길")

                ZStack {
                    LinearGradient(
                        colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    Image("ProductPlaceholder")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 197)
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
                .accessibilityLabel("지도 위치 미등록")

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.locationRows) { row in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text(row.title)
                                .font(EUMTypography.bodySmall)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                                .frame(width: 68, alignment: .leading)

                            Text(row.value)
                                .font(EUMTypography.labelMedium)
                                .tracking(-0.07)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }

                Button(action: onOpenMap) {
                    HStack(spacing: 4) {
                        Text("지도 앱으로 열기")
                            .font(EUMTypography.labelMedium)
                            .tracking(-0.07)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        Image("CompanyExternalLink")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                    .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                    .contentShape(RoundedRectangle(cornerRadius: EUMRadius.button))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("지도 앱으로 열기")
                .accessibilityHint("주소가 임시 정보라 지도 앱과 연결되지 않았습니다")
            }
        }
    }

    private func section<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.vertical, 28)

            divider
        }
    }

    private func sectionHeader(eyebrow: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            overline(eyebrow)
            Text(title)
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)
        }
    }

    private func overline(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.overline)
            .tracking(1.76)
            .foregroundStyle(EUMColor.text3SwiftUI)
    }

    private var divider: some View {
        Rectangle()
            .fill(EUMColor.lineSwiftUI)
            .frame(height: 1)
            .accessibilityHidden(true)
    }
}

private struct CompanyIntroductionSectionChip: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(EUMTypography.labelMedium)
            .tracking(-0.07)
            .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
            .overlay(Capsule().stroke(isSelected ? .clear : EUMColor.lineStrongSwiftUI, lineWidth: 1))
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct CompanyIntroductionBusinessCard: View {
    let area: CompanyIntroductionBusinessArea

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(area.iconName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(area.title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Text(area.description)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 108, alignment: .leading)
        .padding(16)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .accessibilityElement(children: .combine)
    }
}

private struct CompanyIntroductionHistoryRow: View {
    let item: CompanyIntroductionHistoryItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(item.isHighlighted ? "DeliveryTimelineActive" : "DeliveryTimelineInactive")
                .resizable()
                .scaledToFit()
                .frame(width: item.isHighlighted ? 10 : 8, height: item.isHighlighted ? 59 : 57)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.year)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Text(item.description)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 1)
        }
        .accessibilityElement(children: .combine)
    }
}
