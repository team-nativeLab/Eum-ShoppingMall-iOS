import SwiftUI

struct EUMCategoryItem: View {
    enum Layout {
        case tile
        case row
    }

    let title: String
    var iconName: String = "CategoryHardHat"
    var layout: Layout = .tile
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                switch layout {
                case .tile:
                    tileContent
                case .row:
                    rowContent
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private var tileContent: some View {
        VStack(spacing: 6) {
            categoryIcon

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

    private var rowContent: some View {
        HStack(spacing: 14) {
            categoryIcon
                .frame(width: 44, height: 44)
                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
                .overlay(
                    RoundedRectangle(cornerRadius: EUMRadius.large)
                        .stroke(Color(red: 215 / 255, green: 222 / 255, blue: 217 / 255), lineWidth: 1)
                )
                .shadow(color: EUMColor.text1SwiftUI.opacity(0.08), radius: 8, x: 0, y: 4)

            Text(title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image("SectionChevron")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .accessibilityHidden(true)
        }
        .frame(height: 64)
        .contentShape(Rectangle())
    }

    private var categoryIcon: some View {
        Group {
            if let symbolName = categorySymbolName {
                Image(systemName: symbolName)
                    .font(.system(size: 21, weight: .regular))
            } else {
                Image(iconName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 24, height: 24)
        .foregroundStyle(EUMColor.text1SwiftUI)
        .accessibilityHidden(true)
    }

    private var categorySymbolName: String? {
        switch iconName {
        case "CategoryRoad": "cone.fill"
        case "CategoryFire": "flame"
        case "CategoryIndustry": "wrench.and.screwdriver"
        case "CategorySecurity": "video"
        default: nil
        }
    }
}

struct EUMCategoryItemPreview: PreviewProvider {
    static var previews: some View {
        EUMCategoryItem(title: "개인보호장비") {}
    }
}
