import PhotosUI
import SwiftUI

struct ProductReviewRegistrationView: View {
    let product: HomeProduct
    let onBack: () -> Void
    let onSearch: () -> Void

    @State private var rating = 0
    @State private var content = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isShowingCompletion = false
    @FocusState private var isContentFocused: Bool

    private var detail: ProductDetailContent {
        ProductDetailContent(product: product)
    }

    private var canSubmit: Bool {
        rating > 0 && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    productCard
                    purchaseVerification
                    ratingSection
                    reviewContentSection
                    photoSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)

            bottomAction
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .onChange(of: content) { _, newValue in
            guard newValue.count > 1_000 else { return }
            content = String(newValue.prefix(1_000))
        }
        .alert("리뷰가 등록되었습니다.", isPresented: $isShowingCompletion) {
            Button("확인", action: onBack)
        } message: {
            Text("리뷰 등록 결과는 서비스 연결 후 저장됩니다.")
        }
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "리뷰 작성",
            backAccessibilityLabel: "이전 화면으로 돌아가기",
            backAccessibilityIdentifier: "review-registration-back",
            onBack: onBack
        ) {
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("검색")
            .accessibilityIdentifier("review-registration-search")
        }
    }

    private var productCard: some View {
        HStack(spacing: 12) {
            Image(product.imageName ?? "ProductPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .background {
                    LinearGradient(
                        colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(detail.brand)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text(detail.title)
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
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var purchaseVerification: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 24))
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text("김*현")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer()
            Label("구매 인증", systemImage: "checkmark.seal")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .padding(.horizontal, 8)
                .frame(height: 28)
                .background(EUMColor.surfaceSwiftUI, in: Capsule())
        }
        .padding(12)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("상품은 어떠셨나요?")
                .font(EUMTypography.heading3)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text(rating == 0 ? "별점을 선택해 주세요" : "\(rating)점을 선택했어요")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)

            HStack(spacing: 16) {
                ForEach(1...5, id: \.self) { value in
                    Button {
                        rating = value
                    } label: {
                        Image(systemName: value <= rating ? "star.fill" : "star")
                            .font(.system(size: 23))
                            .foregroundStyle(value <= rating ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                            .frame(width: 32, height: 40)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(value)점")
                    .accessibilityAddTraits(rating == value ? .isSelected : [])
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
    }

    private var reviewContentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("리뷰 내용")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .fill(EUMColor.backgroundSwiftUI)
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                if content.isEmpty {
                    Text("상품을 사용해 보신 느낌을 남겨주세요.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .padding(.horizontal, 14)
                        .padding(.top, 16)
                        .accessibilityHidden(true)
                }
                TextEditor(text: $content)
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .focused($isContentFocused)
                    .accessibilityIdentifier("review-registration-content")
            }
            .frame(height: 132)
            Text("\(content.count)/1,000")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사진 첨부")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text("구매 확인된 회원만 사진을 첨부할 수 있어요.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                VStack(spacing: 8) {
                    Image(systemName: selectedPhoto == nil ? "photo.badge.plus" : "photo.fill")
                        .font(.system(size: 22))
                    Text(selectedPhoto == nil ? "사진 추가" : "사진 선택됨")
                        .font(EUMTypography.captionRegular)
                }
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(width: 82, height: 82)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            }
            .accessibilityIdentifier("review-registration-add-photo")
        }
    }

    private var bottomAction: some View {
        EUMButton(title: "리뷰 등록", kind: .primary, size: .large) {
            isContentFocused = false
            isShowingCompletion = true
        }
        .accessibilityIdentifier("review-registration-submit")
        .disabled(!canSubmit)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(EUMColor.backgroundSwiftUI.overlay(alignment: .top) {
            EUMColor.lineSwiftUI.frame(height: 1)
        })
    }
}
