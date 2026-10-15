import SwiftUI

struct SearchNoResultsView: View {
    let searchQuery: String
    let onPopularSearches: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                emptyState
                quotePrompt
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Image("SearchEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .frame(width: 64, height: 64)
                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 32))
                .accessibilityHidden(true)

            Spacer().frame(height: 20)

            Text("'\(searchQuery)'에 대한 결과가 없습니다")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Spacer().frame(height: 8)

            Text("철자를 확인하거나 더 일반적인 단어로\n검색해 보세요.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .multilineTextAlignment(.center)
                .frame(width: 280)

            Spacer().frame(height: 24)

            EUMButton(title: "인기 검색어 보기", kind: .secondary, size: .medium, action: onPopularSearches)
                .frame(width: 160)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 64)
        .padding(.bottom, 32)
    }

    private var quotePrompt: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("찾는 제품이 없나요?")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Text("원하시는 제품을 알려주시면 견적을 보내드립니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
            }

            EUMButton(title: "견적 문의하기", kind: .secondary, size: .medium) {}
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
    }
}
