import SwiftUI

struct EUMCategoryItem: View {
    let title: String
    var iconName: String = "CategoryHardHat"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(iconName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)

                Text(title)
                    .font(EUMTypography.captionMedium)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 68)
            }
            .foregroundStyle(EUMColor.text1SwiftUI)
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .frame(width: 76, height: 84)
            .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .contentShape(RoundedRectangle(cornerRadius: EUMRadius.large))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct EUMCategoryItemPreview: PreviewProvider {
    static var previews: some View {
        EUMCategoryItem(title: "개인보호장비") {}
    }
}
