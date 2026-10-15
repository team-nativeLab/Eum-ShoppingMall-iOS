import SwiftUI
import UIKit

struct DeliveryTrackingView: View {
    @StateObject private var viewModel: DeliveryTrackingViewModel

    let onBack: () -> Void

    init(order: OrderHistoryItem, onBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: DeliveryTrackingViewModel(order: order))
        self.onBack = onBack
    }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 44)
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    deliverySummary
                    DeliveryProgressView(steps: viewModel.steps, currentStepIndex: viewModel.currentStepIndex)
                    DeliveryTimelineView(events: viewModel.events)
                    orderProductSummary
                    deliveryNotice
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }

    private var topBar: some View {
        ZStack {
            Text("배송 조회")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("주문 상세로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var deliverySummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("배송중")
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(EUMColor.surfaceSecondarySwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                .fixedSize()

            Text(viewModel.expectedArrival)
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Text(viewModel.carrierAndNumber)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                EUMButton(title: "복사", kind: .ghost, size: .small) {
                    UIPasteboard.general.string = viewModel.trackingNumber
                }
                .fixedSize()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var orderProductSummary: some View {
        HStack(spacing: 12) {
            Image("ProductPlaceholder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .frame(width: 48, height: 48)
                .background {
                    LinearGradient(
                        colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                .accessibilityHidden(true)
            Text(viewModel.productSummary)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var deliveryNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("DeliveryInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
                .accessibilityHidden(true)
            Text("택배사 사정에 따라 정보가 늦게 반영될 수 있습니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }
}

struct DeliveryTrackingViewPreview: PreviewProvider {
    static var previews: some View {
        DeliveryTrackingView(order: OrderHistoryItem.samples[2], onBack: {})
    }
}
