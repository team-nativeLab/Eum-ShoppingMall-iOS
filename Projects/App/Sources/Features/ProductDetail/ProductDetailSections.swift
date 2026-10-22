import SwiftUI

struct ProductShippingPolicy: Equatable {
    let delivery: String
    let exchangeAndReturnPeriod: String
    let returnShippingFee: String

    static let sample = ProductShippingPolicy(
        delivery: "일반 배송 (2~3일) · 무료",
        exchangeAndReturnPeriod: "수령 후 0일 이내 신청",
        returnShippingFee: "편도 ₩0"
    )
}

struct ProductDetailSections: View {
    let detail: ProductDetailContent
    @Binding var isDetailExpanded: Bool
    let onQuoteTap: () -> Void
    let onProductInquiry: () -> Void
    let onShowAllReviews: () -> Void
    let onShippingDetails: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            productInformation
                .id("information")
            sectionBand
            shippingInformation
                .id("shipping")
            sectionBand
            reviewSection
                .id("reviews")
            sectionBand
            inquirySection
                .id("inquiries")
            sectionBand
            quoteLink
                .padding(.vertical, 24)
        }
    }

    private var productInformation: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("제품 정보")

            VStack(alignment: .leading, spacing: 10) {
                ForEach(detail.specifications) { specification in
                    ProductDetailKeyValueRow(
                        label: specification.label,
                        value: specification.value,
                        labelWidth: 96
                    )
                }
            }

            Image("ProductPlaceholder")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))

            if isDetailExpanded {
                Text("안전한 작업을 위한 제품 상세 정보를 확인할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            }

            EUMButton(
                title: isDetailExpanded ? "상세 정보 접기" : "상세 정보 더 보기",
                kind: .secondary,
                size: .medium
            ) {
                isDetailExpanded.toggle()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    private var shippingInformation: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("배송·교환")
                Spacer()
                Button(action: onShippingDetails) {
                    HStack(spacing: 2) {
                        Text("자세히 보기")
                        Image("SectionChevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("product-shipping-details")
            }

            VStack(alignment: .leading, spacing: 10) {
                ProductDetailKeyValueRow(label: "배송", value: detail.shippingPolicy.delivery, labelWidth: 96)
                ProductDetailKeyValueRow(
                    label: "교환·반품",
                    value: detail.shippingPolicy.exchangeAndReturnPeriod,
                    labelWidth: 96
                )
                ProductDetailKeyValueRow(
                    label: "반품 배송비",
                    value: detail.shippingPolicy.returnShippingFee,
                    labelWidth: 96
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("리뷰 (\(detail.reviewCount))")
                Spacer()
                Button(action: onShowAllReviews) {
                    HStack(spacing: 2) {
                        Text("전체 보기")
                        Image("SectionChevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("product-all-reviews")
            }

            if detail.reviews.isEmpty {
                Text("아직 작성된 리뷰가 없습니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .frame(maxWidth: .infinity, minHeight: 20)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(detail.reviews) { review in
                        reviewCard(review)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    private func reviewCard(_ review: ProductDetailReview) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text(review.author)
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Image(systemName: "checkmark.seal")
                    .font(.system(size: 12))
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Text("구매 인증")
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(EUMColor.backgroundSubtleSwiftUI, in: Capsule())
                Spacer(minLength: 4)
                Text(review.date)
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }

            HStack(spacing: 6) {
                ProductDetailRatingStars(rating: review.rating)
                Text("\(review.rating, specifier: "%.1f")")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("타이틀: - \(review.title)")
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Text(review.content)
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 8) {
                reviewImagePlaceholder
                reviewImagePlaceholder
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var reviewImagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(EUMColor.backgroundSubtleSwiftUI)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 18))
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(width: 56, height: 56)
    }

    private var inquirySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionTitle("상품 문의 (0)")
                Spacer()
                EUMButton(title: "문의하기", kind: .secondary, size: .small, action: onProductInquiry)
                    .frame(width: 76, height: 36)
                    .accessibilityIdentifier("product-inquiry")
            }

            Text("상품에 대해 궁금한 점을 남겨 주세요.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }

    private var quoteLink: some View {
        Button(action: onQuoteTap) {
            HStack(spacing: 10) {
                Image("ProductDetailQuote")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("대량 구매·맞춤 제작은 견적 문의")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("SectionChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(EUMColor.backgroundSubtleSwiftUI)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    private var sectionBand: some View {
        EUMColor.backgroundSubtleSwiftUI.frame(height: 8)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .accessibilityAddTraits(.isHeader)
    }
}

struct ProductDetailRelatedSection: View {
    @State private var favoriteProductIDs = Set<String>()

    let onProductTap: (HomeProduct) -> Void

    private let products = [
        HomeProduct(
            id: "related-boots",
            title: "경량 안전화 4인치",
            price: "₩54,000",
            imageName: nil,
            isFavorite: false,
            isSoldOut: false,
            isPriceHidden: false,
            priceAmount: 54_000,
            brand: "브랜드 B",
            rating: 4.7,
            reviewCount: 6
        ),
        HomeProduct(
            id: "related-harness",
            title: "전신 안전벨트",
            price: nil,
            imageName: nil,
            isFavorite: false,
            isSoldOut: false,
            isPriceHidden: true,
            brand: "브랜드 C",
            rating: 0,
            reviewCount: 0
        ),
        HomeProduct(
            id: "related-gloves",
            title: "코팅 장갑 10켤레",
            price: "₩12,000",
            imageName: nil,
            isFavorite: false,
            isSoldOut: false,
            isPriceHidden: false,
            priceAmount: 12_000,
            brand: "브랜드 A",
            rating: 4.5,
            reviewCount: 3
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("함께 보면 좋은 제품")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, 20)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(products) { product in
                        EUMProductCard(
                            title: product.title,
                            price: product.price,
                            layout: .carousel,
                            isPriceHidden: product.isPriceHidden,
                            rating: product.rating,
                            reviewCount: product.reviewCount,
                            isFavorite: favoriteProductIDs.contains(product.id),
                            onFavoriteTap: { toggleFavorite(productID: product.id) },
                            onTap: { onProductTap(product) },
                            favoriteAccessibilityIdentifier: "related-favorite-\(product.id)"
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
        .id("related")
    }

    private func toggleFavorite(productID: String) {
        if favoriteProductIDs.contains(productID) {
            favoriteProductIDs.remove(productID)
        } else {
            favoriteProductIDs.insert(productID)
        }
    }
}

struct ProductDetailKeyValueRow: View {
    let label: String
    let value: String
    let labelWidth: CGFloat

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(label)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: labelWidth, alignment: .leading)
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(EUMTypography.bodySmall)
        .tracking(-0.07)
        .lineLimit(1)
    }
}
