import PhotosUI
import SwiftUI
import _PhotosUI_SwiftUI

struct ReturnRequestView: View {
    @StateObject private var viewModel: ReturnRequestViewModel

    let onBack: () -> Void
    let onAddressChange: () -> Void
    let onSubmit: (ReturnHistoryItem) -> Void
    let onUnavailable: (String) -> Void

    init(
        order: OrderHistoryItem,
        onBack: @escaping () -> Void,
        onAddressChange: @escaping () -> Void,
        onSubmit: @escaping (ReturnHistoryItem) -> Void,
        onUnavailable: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: ReturnRequestViewModel(order: order))
        self.onBack = onBack
        self.onAddressChange = onAddressChange
        self.onSubmit = onSubmit
        self.onUnavailable = onUnavailable
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    ReturnRequestSegmented(selectedKind: viewModel.selectedKind, onSelect: selectKind)
                    productSection
                    reasonSection
                    photoSection
                    if viewModel.selectedKind == .exchange { exchangeOptionSection }
                    if viewModel.selectedKind != .cancel { pickupSection }
                    if viewModel.selectedKind == .exchange { exchangeCostSection } else { refundSection }
                    ReturnRequestNotice(message: noticeMessage)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
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
                    Image("RequestBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("이전 화면으로 돌아가기")
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
                PhotosPicker(
                    selection: $viewModel.selectedPhotoItems,
                    maxSelectionCount: ReturnRequestPhotoLimit.maximumCount,
                    matching: .images
                ) {
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
            sectionHeading(viewModel.selectedKind == .exchange ? "상품 회수 안내" : "회수 방법")
            HStack(spacing: 24) {
                ForEach(ReturnPickupMethod.allCases) { method in
                    ReturnPickupOption(method: method, isSelected: viewModel.pickupMethod == method) {
                        viewModel.pickupMethod = method
                    }
                }
            }
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.selectedKind == .exchange ? "주문 시 입력한 연락처" : "홍길동 · 010-0000-0000")
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text(viewModel.selectedKind == .exchange ? "주문 시 입력한 배송지" : "(00000) 주소 상세주소")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                EUMButton(title: "변경", kind: .ghost, size: .small, action: onAddressChange)
                    .fixedSize()
            }
            .padding(16)
            .background(.white, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }

    private var refundSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("환불 예정 금액")
            ReturnRefundAmountCard(isCancellation: viewModel.selectedKind == .cancel)
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: viewModel.submitTitle, size: .large) {
                #if DEBUG
                onSubmit(viewModel.makeHistoryItem(applicationNumber: "A-2026-001"))
                #else
                onUnavailable(viewModel.submitMessage())
                #endif
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
        case .cancel: "환불 금액은 주문 상태 및 정책 확인 후 안내됩니다."
        case .returning: "단순 변심 반품은 왕복 배송비가 차감됩니다."
        case .exchange: "교환 비용은 주문 정보 및 운영 정책 확인 후 안내됩니다."
        }
    }

    private var exchangeCostSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeading("교환 비용 안내")
            VStack(spacing: 12) {
                detailRow("상품 금액", value: "신청 후 안내")
                detailRow("교환 배송비", value: "정책에 따라 안내")
                Divider()
                HStack {
                    Text("추가 비용").font(EUMTypography.labelLarge)
                    Spacer()
                    Text("신청 후 안내").font(.custom("NotoSansKR-Bold", size: 24))
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                detailRow("비용 안내", value: "주문 정보 확인 후 안내")
            }
            .padding(16)
            .background(.white, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }

    private func detailRow(_ title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title).foregroundStyle(EUMColor.text2SwiftUI)
            Spacer(minLength: 12)
            Text(value).foregroundStyle(EUMColor.text1SwiftUI).multilineTextAlignment(.trailing)
        }
        .font(EUMTypography.bodySmall)
    }

    private var exchangeOptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("교환 상품 옵션")
                .font(.custom("NotoSansKR-Bold", size: 14))
                .foregroundStyle(Color(red: 26 / 255, green: 33 / 255, blue: 31 / 255))
            optionRow("변경할 옵션", value: "상품 옵션 확인 후 선택")
            optionRow("재고 상태", value: "선택한 주문의 상품 상태를 확인해 주세요.")
        }
        .padding(12)
        .background(Color(red: 247 / 255, green: 249 / 255, blue: 247 / 255),
                    in: RoundedRectangle(cornerRadius: 12))
    }

    private func optionRow(_ title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title).foregroundStyle(Color(red: 77 / 255, green: 87 / 255, blue: 82 / 255))
            Spacer(minLength: 0)
            Text(value).foregroundStyle(Color(red: 26 / 255, green: 33 / 255, blue: 31 / 255))
                .multilineTextAlignment(.trailing)
        }
        .font(.custom("NotoSansKR-Regular", size: 12))
        .frame(maxWidth: .infinity, minHeight: 24, alignment: .topLeading)
        .background(.white)
    }

}

struct ReturnRequestViewPreview: PreviewProvider {
    static var previews: some View {
        ReturnRequestView(
            order: OrderHistoryItem.samples[2],
            onBack: {},
            onAddressChange: {},
            onSubmit: { _ in },
            onUnavailable: { _ in }
        )
    }
}
