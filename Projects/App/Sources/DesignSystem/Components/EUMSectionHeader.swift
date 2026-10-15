import SwiftUI

struct EUMSectionHeader: View {
    let title: String
    var actionTitle: String = "더보기"
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            Spacer(minLength: 8)

            if let action {
                Button(action: action) {
                    HStack(spacing: 2) {
                        Text(actionTitle)
                            .font(EUMTypography.labelExtraSmall)
                        Image("SectionChevron")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .accessibilityHidden(true)
                    }
                    .foregroundStyle(EUMColor.text3SwiftUI)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(actionTitle)
            }
        }
        .frame(height: 26)
    }
}

struct EUMSectionHeaderPreview: PreviewProvider {
    static var previews: some View {
        EUMSectionHeader(title: "추천 제품", action: {})
            .padding(20)
    }
}
