import SwiftUI

struct CouponsView: View {
    @StateObject private var viewModel = CouponsViewModel()
    @State private var couponCode = ""
    @State private var presentedMessage: String?

    let onBack: () -> Void
    let onPointsTap: () -> Void
    let onBrowseProducts: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            if viewModel.availableCoupons.isEmpty && viewModel.completedCoupons.isEmpty {
                emptyState
                    .padding(20)
                    .frame(maxHeight: .infinity)
            } else {
            ScrollView {
                VStack(spacing: 20) {
                    registerForm
                    pointsBalance
                    couponTabs
                    couponList
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .alert("쿠폰 등록", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "쿠폰함",
            backAccessibilityLabel: "마이페이지로 돌아가기",
            onBack: onBack
        ) {
            Color.clear.frame(width: 44, height: 44)
        }
    }

    private var registerForm: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("쿠폰 코드를 입력해 주세요", text: $couponCode)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                    .stroke(EUMColor.lineControlSwiftUI, lineWidth: 1)
                }
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .accessibilityLabel("쿠폰 코드")

            EUMButton(title: "등록", kind: .primary, size: .medium) {
                presentedMessage = viewModel.registerCoupon(code: couponCode)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var pointsBalance: some View {
        Button(action: onPointsTap) {
            HStack(spacing: 8) {
                Image("CouponCoins")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("보유 적립금")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Spacer()
                Text("0원")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Image("ProductOptionChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .contentShape(RoundedRectangle(cornerRadius: EUMRadius.large))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("보유 적립금 0원")
    }

    private var couponTabs: some View {
        HStack(spacing: 4) {
            ForEach(CouponListTab.allCases) { tab in
                Button {
                    viewModel.selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                        .foregroundStyle(tab == viewModel.selectedTab ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background {
                            if tab == viewModel.selectedTab {
                                RoundedRectangle(cornerRadius: EUMRadius.small)
                                    .fill(EUMColor.backgroundSwiftUI)
                                    .shadow(color: Color.black.opacity(0.06), radius: 3, y: 1)
                            }
                        }
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(tab == viewModel.selectedTab ? .isSelected : [])
            }
        }
        .padding(4)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
    }

    @ViewBuilder
    private var couponList: some View {
        if viewModel.couponsForSelectedTab.isEmpty {
            emptyState
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.couponsForSelectedTab) { coupon in
                    CouponTicketView(coupon: coupon)
                }
            }
        }
    }

    private var emptyState: some View {
        AccountEmptyState(
            title: viewModel.selectedTab == .available ? "사용 가능한 쿠폰이 없습니다" : "사용 완료·만료된 쿠폰이 없습니다",
            message: "보유한 쿠폰은 이곳에서\n확인할 수 있어요.",
            actionTitle: "상품 보러가기", actionIdentifier: "coupons-empty-browse", onAction: onBrowseProducts
        )
    }

    private var messagePresented: Binding<Bool> {
        Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )
    }
}

private struct CouponTicketView: View {
    let coupon: Coupon

    var body: some View {
        HStack(spacing: 0) {
            ticketDetails
                .frame(maxWidth: .infinity, alignment: .leading)
            perforation
                .frame(width: 1)
            couponScope
                .frame(width: 76)
        }
        .frame(minHeight: 132)
        .background(EUMColor.backgroundSwiftUI)
        .overlay {
            RoundedRectangle(cornerRadius: EUMRadius.large)
                .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
        }
        .overlay(alignment: .topTrailing) {
            notch
                .offset(x: -70, y: -6)
        }
        .overlay(alignment: .bottomTrailing) {
            notch
                .offset(x: -70, y: 6)
        }
        .accessibilityElement(children: .combine)
    }

    private var ticketDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(coupon.discount)
                    .font(Font.custom("NotoSansKR-Bold", size: 22, relativeTo: .title2))
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 4)
                if let remainingDays = coupon.remainingDays {
                    Text(remainingDays)
                        .font(EUMTypography.labelExtraSmall)
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                        .padding(.horizontal, 6)
                        .frame(height: 20)
                        .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                }
            }
            Text(coupon.title)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
            Text(coupon.condition)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(coupon.expiry)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
        }
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .padding(.vertical, 16)
    }

    private var perforation: some View {
        Rectangle()
            .fill(Color(uiColor: EUMColor.line))
            .frame(width: 1)
            .overlay {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundStyle(Color(uiColor: EUMColor.line))
            }
    }

    private var couponScope: some View {
        VStack(spacing: 4) {
            Image("CouponTicket")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(coupon.scope)
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    private var notch: some View {
        Circle()
            .fill(EUMColor.backgroundSwiftUI)
            .frame(width: 12, height: 12)
            .overlay(Circle().stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}

struct CouponsViewPreview: PreviewProvider {
    static var previews: some View {
        CouponsView(onBack: {}, onPointsTap: {}, onBrowseProducts: {})
    }
}
