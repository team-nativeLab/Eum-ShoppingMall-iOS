import SwiftUI

struct ProductDetailSpecification: Identifiable {
    let label: String
    let value: String

    var id: String { label }
}

struct ProductDetailReview: Identifiable {
    let author: String
    let date: String
    let rating: Double
    let title: String
    let content: String

    var id: String { author + date }
}

struct ProductDetailContent {
    let brand: String
    let title: String
    let description: String
    let rating: Double?
    let reviewCount: Int
    let originalPrice: String?
    let discountPercentage: Int?
    let certification: String
    let specifications: [ProductDetailSpecification]
    let shippingPolicy: ProductShippingPolicy
    let reviews: [ProductDetailReview]

    init(product: HomeProduct) {
        if product.id.contains("helmet") || product.title.localizedCaseInsensitiveContains("안전모") {
            brand = "세이프가드"
            title = "ABS 안전모 (내관 조절형)"
            description = "가볍고 튼튼한 ABS 안전모입니다.\n내관 조절형으로 편안하게 착용할 수 있습니다."
            rating = 4.7
            reviewCount = 3
            originalPrice = product.originalPrice ?? "₩22,000"
            discountPercentage = product.discountPercentage ?? 18
            certification = "KCs 안전인증"
            specifications = [
                ProductDetailSpecification(label: "모델명", value: "SG-H100"),
                ProductDetailSpecification(label: "소재", value: "ABS"),
                ProductDetailSpecification(label: "사이즈", value: "내관 조절형"),
                ProductDetailSpecification(label: "안전인증", value: "KCs 안전인증"),
                ProductDetailSpecification(label: "원산지", value: "대한민국"),
                ProductDetailSpecification(label: "제조사", value: "세이프가드")
            ]
            shippingPolicy = ProductShippingPolicy(
                delivery: "일반 배송 (2~3일) · 무료",
                exchangeAndReturnPeriod: "수령 후 7일 이내 접수",
                returnShippingFee: "편도 ₩3,000"
            )
            reviews = [
                ProductDetailReview(
                    author: "이*현",
                    date: "2026.10.20",
                    rating: 5.0,
                    title: "조절형",
                    content: "가볍고 튼튼해요. 내관 조절이 쉬워 현장에서 오래 착용해도 편합니다."
                )
            ]
        } else {
            let brandName = product.brand ?? "브랜드명"
            brand = brandName
            title = product.title
            description = "제품에 대한 간단한 설명이 들어갑니다.\n안전한 작업을 위한 필수 아이템입니다."
            rating = product.rating
            reviewCount = product.reviewCount ?? 0
            originalPrice = product.originalPrice
            discountPercentage = product.discountPercentage
            certification = "KC 인증 0000-0000"
            specifications = [
                ProductDetailSpecification(label: "모델명", value: "모델명"),
                ProductDetailSpecification(label: "소재", value: "소재 정보"),
                ProductDetailSpecification(label: "사이즈", value: "S / M / L / XL"),
                ProductDetailSpecification(label: "안전인증", value: "KC 인증 0000-0000"),
                ProductDetailSpecification(label: "원산지", value: "원산지"),
                ProductDetailSpecification(label: "제조사", value: brandName)
            ]
            shippingPolicy = .sample
            reviews = []
        }
    }
}

struct ProductDetailRatingStars: View {
    let rating: Double
    var size: CGFloat = 16

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(index < Int(rating) ? "RatingStarFilled" : "RatingStarOutline")
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
        .accessibilityLabel("평점 \(rating, specifier: "%.1f")점")
    }
}

struct ProductDetailSummaryView: View {
    let product: HomeProduct
    let detail: ProductDetailContent

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text(detail.brand)
                                .font(EUMTypography.captionMedium)
                                .foregroundStyle(EUMColor.text3SwiftUI)

                            if product.isPriceHidden {
                                Text("견적 상품")
                                    .font(EUMTypography.labelExtraSmall)
                                    .foregroundStyle(EUMColor.text2SwiftUI)
                                    .padding(.horizontal, 6)
                                    .frame(height: 20)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                            }
                        }

                        Text(detail.title)
                            .font(EUMTypography.heading2)
                            .tracking(-0.44)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                    }

                    if let rating = detail.rating {
                        HStack(spacing: 8) {
                            ProductDetailRatingStars(rating: rating, size: 20)
                            Text("\(rating, specifier: "%.1f") · 리뷰 \(detail.reviewCount)개")
                                .font(EUMTypography.captionRegular)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                        }
                    }

                    if product.isPriceHidden {
                        Text("가격 문의")
                            .font(EUMTypography.heading2)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    } else {
                        HStack(spacing: 4) {
                            if let discount = detail.discountPercentage {
                                Text("\(discount)%")
                                    .font(EUMTypography.captionMedium)
                                    .foregroundStyle(EUMColor.dangerSwiftUI)
                            }
                            if let originalPrice = detail.originalPrice {
                                Text(originalPrice)
                                    .font(EUMTypography.bodySmall)
                                    .strikethrough()
                                    .foregroundStyle(EUMColor.text3SwiftUI)
                            }
                            if let price = product.price {
                                Text(price)
                                    .font(Font.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                                    .tracking(-0.36)
                                    .foregroundStyle(detail.discountPercentage == nil ? EUMColor.text1SwiftUI : EUMColor.dangerSwiftUI)
                            }
                        }
                    }
                }

                Text(detail.description)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .lineSpacing(0)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 8) {
                ProductDetailKeyValueRow(label: "배송", value: detail.shippingPolicy.delivery, labelWidth: 72)
                ProductDetailKeyValueRow(label: "인증", value: detail.certification, labelWidth: 72)
                ProductDetailKeyValueRow(label: "제조사", value: detail.brand, labelWidth: 72)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.backgroundSubtleSwiftUI)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}
