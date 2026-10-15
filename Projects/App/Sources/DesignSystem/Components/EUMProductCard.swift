import SwiftUI

struct EUMProductCard: View {
    enum Layout: Equatable {
        case carousel
        case grid

        var width: CGFloat { self == .carousel ? 148 : 169 }
        var imageSize: CGFloat { self == .carousel ? 132 : 153 }
    }

    let title: String
    let price: String?
    var layout: Layout = .grid
    var imageName: String?
    var isSoldOut = false
    var isPriceHidden = false
    var hiddenPriceBadgeTitle = "금액 미표시"
    var isFavorite = false
    var onFavoriteTap: () -> Void = {}
    var onTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                productImage
                    .frame(width: layout.imageSize, height: layout.imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                    .overlay {
                        if isSoldOut {
                            EUMColor.inverseSwiftUI.opacity(0.6)
                                .overlay {
                                    Text("품절")
                                        .font(EUMTypography.labelExtraSmall)
                                        .foregroundStyle(EUMColor.inverseSwiftUI)
                                        .padding(.horizontal, 6)
                                        .frame(height: 20)
                                        .background(EUMColor.text2SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                                }
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        if isPriceHidden {
                            Text(hiddenPriceBadgeTitle)
                                .font(EUMTypography.labelExtraSmall)
                                .foregroundStyle(EUMColor.text2SwiftUI)
                                .padding(.horizontal, 6)
                                .frame(height: 20)
                                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                                .overlay {
                                    RoundedRectangle(cornerRadius: EUMRadius.small)
                                        .stroke(Color(uiColor: EUMColor.lineStrong), lineWidth: 1)
                                }
                                .padding(8)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        Button(action: onFavoriteTap) {
                            Image(isFavorite ? "ProductFavoriteSelected" : "ProductFavorite")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(isFavorite ? "찜 취소" : "찜하기")
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .lineLimit(1)
                        .foregroundStyle(isSoldOut ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)

                    if isPriceHidden {
                        Text("가격 문의")
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    } else if let price {
                        Text(price)
                            .font(Font.custom("NotoSansKR-Bold", size: 16, relativeTo: .body))
                            .tracking(-0.08)
                            .foregroundStyle(isSoldOut ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .frame(width: layout.width, alignment: .topLeading)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))
        .contentShape(RoundedRectangle(cornerRadius: EUMRadius.button))
        .onTapGesture(perform: onTap)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var productImage: some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.949, green: 0.949, blue: 0.949),
                        Color(red: 0.91, green: 0.91, blue: 0.91)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Image("ProductPlaceholder")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
        }
    }
}
