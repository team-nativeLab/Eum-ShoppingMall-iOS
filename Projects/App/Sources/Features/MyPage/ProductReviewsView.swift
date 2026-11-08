import SwiftUI

struct ProductReviewsView: View {
    private struct Review: Identifiable {
        let author: String
        let date: String
        let rating: Double
        let option: String
        let content: String
        let photoCount: Int

        var id: String { author + date }
    }

    private enum ReviewFilter: Equatable {
        case all
        case photos
    }

    private let product: HomeProduct
    let onBack: () -> Void
    let onSearch: () -> Void
    let onWriteReview: () -> Void

    @State private var selectedFilter = ReviewFilter.all
    @State private var selectedSort = "최신순"

    private let reviews = [
        Review(
            author: "이*현",
            date: "2026.10.20",
            rating: 5,
            option: "화이트 · 조절형",
            content: "가볍고 튼튼해요. 내관 조절이 쉬워 현장에서 오래 착용해도 편합니다.",
            photoCount: 2
        ),
        Review(
            author: "박*은",
            date: "2026.10.12",
            rating: 4,
            option: "화이트",
            content: "마감이 깔끔하고 착용감이 안정적입니다. 배송도 빠르게 도착했어요.",
            photoCount: 0
        ),
        Review(
            author: "최*민",
            date: "2026.10.05",
            rating: 4,
            option: "화이트 · 조절형",
            content: "가볍고 착용과 조절이 편리해 작업할 때 유용합니다.",
            photoCount: 1
        )
    ]

    init(product: HomeProduct, onBack: @escaping () -> Void, onSearch: @escaping () -> Void, onWriteReview: @escaping () -> Void) {
        self.product = product
        self.onBack = onBack
        self.onSearch = onSearch
        self.onWriteReview = onWriteReview
    }

    private var productDetail: ProductDetailContent { ProductDetailContent(product: product) }

    private var visibleReviews: [Review] {
        let filtered = selectedFilter == .photos ? reviews.filter { $0.photoCount > 0 } : reviews
        switch selectedSort {
        case "평점 높은순": return filtered.sorted { $0.rating > $1.rating }
        case "평점 낮은순": return filtered.sorted { $0.rating < $1.rating }
        default: return filtered
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "전체 리뷰",
                backAccessibilityLabel: "상품 상세로 돌아가기",
                backAccessibilityIdentifier: "product-reviews-back",
                onBack: onBack
            ) {
                Button(action: onSearch) {
                    Image("DesignSearch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("검색")
                .accessibilityIdentifier("product-reviews-search")
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    productSummary
                    ratingSummary
                    reviewControls
                    ForEach(visibleReviews) { review in
                        reviewCard(review)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
    }

    private var productSummary: some View {
        HStack(spacing: 12) {
            placeholderImage(size: 64, iconSize: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(productDetail.brand)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text(productDetail.title)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                Text("화이트 · 조절형")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(height: 88)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var ratingSummary: some View {
        HStack(spacing: 8) {
            Text("4.7")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(width: 50, alignment: .leading)
            HStack(spacing: 7) {
                ForEach(0..<5, id: \.self) { _ in
                    Image("RatingStarFilled")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
            Text("리뷰 3개")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineLimit(1)
                .fixedSize()
        }
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var reviewControls: some View {
        HStack(spacing: 8) {
            filterButton(title: "전체 3", filter: .all)
            filterButton(title: "사진 리뷰", filter: .photos)
            Spacer(minLength: 4)
            Menu {
                ForEach(["최신순", "평점 높은순", "평점 낮은순"], id: \.self) { sort in
                    Button(sort) { selectedSort = sort }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedSort)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.leading, 14)
                .padding(.trailing, 10)
                .frame(height: 32)
                .background(EUMColor.backgroundSwiftUI, in: Capsule())
                .overlay(Capsule().stroke(EUMColor.text1SwiftUI, lineWidth: 1))
            }
            .accessibilityIdentifier("product-reviews-sort")
        }
        .frame(height: 36)
    }

    private func filterButton(title: String, filter: ReviewFilter) -> some View {
        let isSelected = selectedFilter == filter
        return Button {
            selectedFilter = filter
        } label: {
            Text(title)
                .font(EUMTypography.captionMedium)
                .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                .frame(width: 74, height: 36)
                .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSubtleSwiftUI, in: Capsule())
                .overlay(Capsule().stroke(isSelected ? Color.clear : EUMColor.lineSwiftUI, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(filter == .all ? "product-reviews-filter-all" : "product-reviews-filter-photos")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            Button(action: onWriteReview) {
                Text("리뷰 작성")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.inverseSwiftUI)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("product-reviews-write")
            .padding(.horizontal, 20)
            .padding(.top, 11)
            .padding(.bottom, 16)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea(edges: .bottom))
    }
}

private extension ProductReviewsView {
    private func reviewCard(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            reviewHeader(review)
            reviewRating(review)
            reviewOptionAndText(review)
            if review.photoCount > 0 { reviewPhotos(review) }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func reviewHeader(_ review: Review) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                ZStack {
                    Circle().fill(EUMColor.surfaceSecondarySwiftUI)
                    Image("MyPageProfile")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
                .frame(width: 32, height: 32)

                Text(review.author)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image("ProfileEditCheck")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    Text("구매 인증")
                        .font(EUMTypography.captionMedium)
                        .lineLimit(1)
                }
                .foregroundStyle(Color(red: 10 / 255, green: 110 / 255, blue: 87 / 255))
                .padding(.horizontal, 4)
                .frame(height: 22)
                .background(Color(red: 231 / 255, green: 245 / 255, blue: 241 / 255), in: Capsule())
            }
            Spacer(minLength: 4)
            Text(review.date)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .lineLimit(1)
                .fixedSize()
        }
    }

    private func reviewRating(_ review: Review) -> some View {
        HStack(spacing: 8) {
            ProductDetailRatingStars(rating: review.rating)
            Text("\(review.rating, specifier: "%.1f")")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
    }

    private func reviewOptionAndText(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.option)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Text(review.content)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func reviewPhotos(_ review: Review) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<review.photoCount, id: \.self) { _ in
                placeholderImage(size: 52, iconSize: 32)
            }
        }
    }

    private func placeholderImage(size: CGFloat, iconSize: CGFloat) -> some View {
        ZStack {
            LinearGradient(
                colors: [EUMColor.imagePlaceholderSecondaryTopSwiftUI, EUMColor.imagePlaceholderSecondaryBottomSwiftUI],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image("ProductPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
        }
        .frame(width: size, height: size)
        .clipped()
    }
}
