import SwiftUI

struct GuestRecentProduct: Identifiable {
    let id: String
    let title: String
    let price: String

    static let mock = (0..<3).map { index in
        GuestRecentProduct(id: "recent-\(index)", title: "제품명", price: "₩00,000")
    }
}

@MainActor
final class GuestMyPageViewModel: ObservableObject {
    let recentProducts = GuestRecentProduct.mock
    let menuItems = [
        MyPageMenuItem(title: "고객센터", iconName: "MyPageSupport"),
        MyPageMenuItem(title: "공지사항", iconName: "MyPageNotices")
    ]
}

struct GuestMyPageView: View {
    @StateObject private var viewModel = GuestMyPageViewModel()
    @State private var presentedMessage: String?

    let cartCount: Int
    let onSelectTab: (EUMTabBar.Tab) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 32) {
                    loginPanel
                    recentlyViewed
                    menuCard
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            EUMTabBar(selectedTab: .account, cartCount: cartCount, onSelect: onSelectTab)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("마이페이지")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Spacer()
                Button {
                    presentedMessage = "설정 화면은 아직 연결되지 않았어요."
                } label: {
                    Image("MyPageSettings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("설정")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var loginPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("로그인하면 주문 정보를\n한곳에서 관리할 수 있습니다")
                    .font(EUMTypography.heading3)
                    .tracking(-0.27)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)

                Text("주문·배송 조회와 찜한 상품을\n한 곳에서 확인할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            EUMButton(title: "로그인 / 회원가입", kind: .primary, size: .medium) {
                presentedMessage = "로그인과 회원가입은 아직 연결되지 않았어요."
            }
        }
        .padding(24)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private var recentlyViewed: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("최근 본 상품")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .accessibilityAddTraits(.isHeader)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(viewModel.recentProducts) { product in
                        EUMProductCard(
                            title: product.title,
                            price: product.price,
                            layout: .carousel,
                            onFavoriteTap: { presentedMessage = "찜 기능은 로그인 후 이용할 수 있어요." },
                            onTap: { presentedMessage = "상품 상세 화면은 아직 연결되지 않았어요." }
                        )
                    }
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
            }
            .scrollIndicators(.hidden)
        }
    }

    private var menuCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.menuItems.enumerated()), id: \.element.id) { index, item in
                Button {
                    presentedMessage = "\(item.title) 화면은 아직 연결되지 않았어요."
                } label: {
                    HStack(spacing: 12) {
                        Image(item.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(item.title)
                            .font(.custom("NotoSansKR-Regular", size: 16))
                            .tracking(-0.16)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image("MyPageChevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.horizontal, EUMSpacing.homeContentInset)
                    .frame(height: 56)
                    .contentShape(Rectangle())
                    .overlay(alignment: .bottom) {
                        if index < viewModel.menuItems.count - 1 {
                            Rectangle()
                                .fill(EUMColor.lineSwiftUI)
                                .frame(height: 1)
                                .padding(.horizontal, EUMSpacing.homeContentInset)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(item.title)
            }
        }
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }
}

struct GuestMyPageViewPreview: PreviewProvider {
    static var previews: some View {
        GuestMyPageView(cartCount: 3, onSelectTab: { _ in })
    }
}
