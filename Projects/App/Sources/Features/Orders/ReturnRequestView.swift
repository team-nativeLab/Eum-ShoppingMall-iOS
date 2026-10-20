import PhotosUI
import SwiftUI
import _PhotosUI_SwiftUI

struct ReturnRequestView: View {
    @StateObject private var viewModel: ReturnRequestViewModel

    let onBack: () -> Void
    let onAddressChange: () -> Void
    let onSubmit: (String) -> Void

    init(
        order: OrderHistoryItem,
        onBack: @escaping () -> Void,
        onAddressChange: @escaping () -> Void,
        onSubmit: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: ReturnRequestViewModel(order: order))
        self.onBack = onBack
        self.onAddressChange = onAddressChange
        self.onSubmit = onSubmit
    }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 44)
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    ReturnRequestSegmented(selectedKind: viewModel.selectedKind, onSelect: selectKind)
                    productSection
                    reasonSection
                    if viewModel.selectedKind != .cancel {
                        photoSection
                        pickupSection
                    }
                    if viewModel.selectedKind == .exchange {
                        exchangeOptionSection
                    } else {
                        refundSection
                    }
                    ReturnRequestNotice(message: noticeMessage)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
        .onChange(of: viewModel.selectedPhotoItems) { _, items in
            Task { await viewModel.loadSelectedPhotos(from: items) }
        }
    }

    private var topBar: some View {
        ZStack {
            Text(viewModel.pageTitle)
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

    private var productSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("상품 선택")
            ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
                ReturnRequestProductRow(
                    product: product,
                    isSelected: viewModel.isSelected(product),
                    quantity: viewModel.quantity(for: product),
                    onToggle: { viewModel.toggleProduct(product) },
                    onDecrease: { viewModel.adjustQuantity(for: product, by: -1) },
                    onIncrease: { viewModel.adjustQuantity(for: product, by: 1) }
                )
                if index < viewModel.products.count - 1 {
                    Rectangle()
                        .fill(EUMColor.lineSwiftUI)
                        .frame(height: 1)
                }
            }
        }
    }

    private var reasonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("사유 선택")
            ReturnRequestReasonGrid(selectedReason: viewModel.selectedReason) {
                viewModel.selectedReason = $0
            }
            ReturnRequestTextEditor(text: $viewModel.detailedReason)
        }
    }

    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("사진 첨부 (선택)")
            HStack(alignment: .top, spacing: 8) {
                PhotosPicker(selection: $viewModel.selectedPhotoItems, matching: .images) {
                    ReturnRequestPhotoTile()
                }
                .buttonStyle(.plain)

                ForEach(viewModel.photos) { photo in
                    ReturnRequestPhotoThumbnail(photo: photo) {
                        viewModel.removePhoto(id: photo.id)
                    }
                }
            }
            Text("불량·오배송은 사진을 첨부하면 더 빠르게 처리됩니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var pickupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("회수 방법")
            HStack(spacing: 24) {
                ForEach(ReturnPickupMethod.allCases) { method in
                    ReturnPickupOption(method: method, isSelected: viewModel.pickupMethod == method) {
                        viewModel.pickupMethod = method
                    }
                }
            }
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("홍길동 · 010-0000-0000")
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("(00000) 주소 상세주소")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                EUMButton(title: "변경", kind: .ghost, size: .small, action: onAddressChange)
                    .fixedSize()
            }
            .padding(16)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        }
    }

    private var refundSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("환불 예정 금액")
            ReturnRefundAmountCard()
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: viewModel.submitTitle, size: .large) {
                onSubmit(viewModel.submitMessage())
            }
            .disabled(!viewModel.canSubmit)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }

    private func sectionHeading(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    private func selectKind(_ kind: ReturnRequestKind) {
        viewModel.selectedKind = kind
    }

    private var noticeMessage: String {
        switch viewModel.selectedKind {
        case .cancel: "취소 가능 여부와 환불 금액은 주문 서비스 연동 후 확인할 수 있습니다."
        case .returning: "단순 변심 반품은 왕복 배송비가 차감됩니다."
        case .exchange: "교환 옵션, 재고와 추가 비용은 주문 서비스 연동 후 확인할 수 있습니다."
        }
    }

    private var exchangeOptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("교환 옵션")
            Text("교환 가능한 옵션은 주문 서비스 연동 후 선택할 수 있습니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        }
    }
}

struct ReturnRequestViewPreview: PreviewProvider {
    static var previews: some View {
        ReturnRequestView(
            order: OrderHistoryItem.samples[2],
            onBack: {},
            onAddressChange: {},
            onSubmit: { _ in }
        )
    }
}
