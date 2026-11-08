import SwiftUI

struct QuoteInquiryIntroSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("CUSTOM ORDER")
                    .font(EUMTypography.overline)
                    .tracking(1.76)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text("현장을 위한\n맞춤 안전 솔루션")
                    .font(.custom("NotoSansKR-Bold", size: 26, relativeTo: .title))
                    .tracking(-0.65)
                    .lineSpacing(0)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityAddTraits(.isHeader)
            }

            HStack(spacing: 6) {
                processStep("문의 접수")
                processChevron
                processStep("상담")
                processChevron
                processStep("견적서 발송")
                processChevron
                processStep("제작")
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }

    private func processStep(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.captionMedium)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .fixedSize()
    }

    private var processChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 9, weight: .medium))
            .foregroundStyle(EUMColor.text3SwiftUI)
            .accessibilityHidden(true)
    }
}

struct QuoteInquiryProductsSection: View {
    @ObservedObject var viewModel: QuoteInquiryViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("문의 상품 (\(viewModel.products.count))")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                EUMButton(title: "상품 추가", kind: .ghost, size: .small) {
                    viewModel.addSampleProduct()
                }
                .frame(width: 79)
            }

            ForEach(viewModel.products) { product in
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.95, green: 0.95, blue: 0.95), Color(red: 0.91, green: 0.91, blue: 0.91)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product.name)
                            .font(EUMTypography.labelMedium)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        Text("옵션: \(product.option) · 수량 \(product.quantity)")
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                    }
                    Spacer(minLength: 0)
                    Button {
                        viewModel.removeProduct(id: product.id)
                    } label: {
                        Image("ProductOptionClose")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(product.name) 삭제")
                }
            }
        }
        .padding(16)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}

struct QuoteInquiryBottomAction: View {
    let isEnabled: Bool
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("필수 항목을 모두 입력하면 접수할 수 있습니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            EUMButton(title: "견적 문의 전송", size: .large, action: onSubmit)
                .disabled(!isEnabled)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }
}
