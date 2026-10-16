import SwiftUI

struct MyPageShortcut: Identifiable, Equatable {
    let title: String
    let iconName: String

    var id: String { title }

    static let all = [
        MyPageShortcut(title: "주문내역", iconName: "MyPageOrder"),
        MyPageShortcut(title: "찜한 상품", iconName: "MyPageFavorites"),
        MyPageShortcut(title: "최근 본 상품", iconName: "MyPageRecent"),
        MyPageShortcut(title: "쿠폰함", iconName: "MyPageCoupons")
    ]
}

struct MyPageOrderStatus: Identifiable, Equatable {
    let title: String
    let count: Int

    var id: String { title }

    static let mock = [
        MyPageOrderStatus(title: "입금대기", count: 0),
        MyPageOrderStatus(title: "결제완료", count: 0),
        MyPageOrderStatus(title: "배송준비", count: 0),
        MyPageOrderStatus(title: "배송중", count: 0),
        MyPageOrderStatus(title: "배송완료", count: 0)
    ]
}

struct MyPageMenuItem: Identifiable, Equatable {
    let title: String
    let iconName: String

    var id: String { title }

    static let all = [
        MyPageMenuItem(title: "내 정보 관리", iconName: "MyPageInformation"),
        MyPageMenuItem(title: "배송지 관리", iconName: "MyPageAddress"),
        MyPageMenuItem(title: "취소·반품·교환 내역", iconName: "MyPageReturns"),
        MyPageMenuItem(title: "견적 문의 내역", iconName: "MyPageQuoteInquiries"),
        MyPageMenuItem(title: "1:1 문의 내역", iconName: "MyPageContactInquiries"),
        MyPageMenuItem(title: "고객센터", iconName: "MyPageSupport"),
        MyPageMenuItem(title: "공지사항", iconName: "MyPageNotices")
    ]
}

@MainActor
final class MyPageViewModel: ObservableObject {
    let memberName = "홍길동"
    let memberType = "사업자"
    let greeting = "안녕하세요!"
    let shortcuts = MyPageShortcut.all
    let orderStatuses = MyPageOrderStatus.mock
    let menuItems = MyPageMenuItem.all
}

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @State private var presentedMessage: String?
    @State private var isShowingAnnouncements = false
    @State private var selectedAnnouncement: AnnouncementItem?
    @State private var isShowingCustomerCenter = false

    let cartCount: Int
    let onSelectTab: (EUMTabBar.Tab) -> Void
    var onOrderHistoryTap: () -> Void = {}
    var onFavoritesTap: () -> Void = {}
    var onRecentlyViewedTap: () -> Void = {}
    var onCouponsTap: () -> Void = {}
    var onAddressesTap: () -> Void = {}
    var onQuoteHistoryTap: () -> Void = {}
    var onContactHistoryTap: () -> Void = {}
    var onReturnsHistoryTap: () -> Void = {}
    var onAccountVerificationTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                pageContent
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
        .overlay {
            if isShowingCustomerCenter {
                CustomerCenterView(
                    onBack: { isShowingCustomerCenter = false },
                    onCall: { presentedMessage = "고객센터 전화 연결은 번호 연동 후 이용할 수 있어요." },
                    onContact: onContactHistoryTap
                )
            } else if isShowingAnnouncements {
                if let selectedAnnouncement {
                    AnnouncementDetailView(
                        announcement: selectedAnnouncement,
                        onBack: { self.selectedAnnouncement = nil },
                        onDownload: { presentedMessage = "\($0)은 파일 서비스 연동 후 다운로드할 수 있어요." }
                    )
                } else {
                    AnnouncementsView(
                        onBack: { isShowingAnnouncements = false },
                        onOpenAnnouncement: { selectedAnnouncement = $0 }
                    )
                }
            }
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
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("설정")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var pageContent: some View {
        VStack(spacing: 24) {
            profileGroup
            accountSections
        }
        .padding(.bottom, 24)
    }

    private var accountSections: some View {
        VStack(spacing: 16) {
            orderStatusGroup
            menuCard
        }
    }

    private var profileGroup: some View {
        VStack(spacing: 0) {
            Button {
                onAccountVerificationTap()
            } label: {
                HStack(spacing: 16) {
                    Image("MyPageProfile")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(width: 36, height: 36)
                        .frame(width: 72, height: 72)
                        .background(EUMColor.lineSwiftUI, in: Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text("\(viewModel.memberName)님")
                                .font(EUMTypography.heading2)
                                .tracking(-0.44)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                            Text(viewModel.memberType)
                                .font(EUMTypography.labelExtraSmall)
                                .foregroundStyle(EUMColor.text2SwiftUI)
                                .padding(.horizontal, 6)
                                .frame(height: 20)
                                .overlay(RoundedRectangle(cornerRadius: EUMRadius.small).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                        }
                        Text(viewModel.greeting)
                            .font(EUMTypography.bodySmall)
                            .tracking(-0.07)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image("MyPageChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .frame(height: 112)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(viewModel.memberName)님, \(viewModel.memberType), 내 정보 관리")

            HStack(spacing: 0) {
                ForEach(viewModel.shortcuts) { shortcut in
                    Button {
                        if shortcut.title == "주문내역" {
                            onOrderHistoryTap()
                        } else if shortcut.title == "찜한 상품" {
                            onFavoritesTap()
                        } else if shortcut.title == "최근 본 상품" {
                            onRecentlyViewedTap()
                        } else if shortcut.title == "쿠폰함" {
                            onCouponsTap()
                        } else {
                            showUnavailable(shortcut.title)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(shortcut.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text(shortcut.title)
                                .font(EUMTypography.captionMedium)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
        }
    }

    private var orderStatusGroup: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주문 현황")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, EUMSpacing.homeContentInset)

            HStack(spacing: 0) {
                ForEach(viewModel.orderStatuses) { status in
                    VStack(spacing: 4) {
                        Text("\(status.count)")
                            .font(EUMTypography.heading3)
                            .tracking(-0.27)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                        Text(status.title)
                            .font(.custom("NotoSansKR-Regular", size: 12))
                            .foregroundStyle(EUMColor.text2SwiftUI)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
                }
            }
            .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .padding(.horizontal, EUMSpacing.homeContentInset)
        }
    }

    private var menuCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.menuItems.enumerated()), id: \.element.id) { index, item in
                Button {
                    if item.title == "배송지 관리" {
                        onAddressesTap()
                    } else if item.title == "취소·반품·교환 내역" {
                        onReturnsHistoryTap()
                    } else if item.title == "견적 문의 내역" {
                        onQuoteHistoryTap()
                    } else if item.title == "1:1 문의 내역" {
                        onContactHistoryTap()
                    } else if item.title == "공지사항" {
                        isShowingAnnouncements = true
                    } else if item.title == "고객센터" {
                        isShowingCustomerCenter = true
                    } else {
                        showUnavailable(item.title)
                    }
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

    private func showUnavailable(_ destination: String) {
        presentedMessage = "\(destination) 화면은 아직 연결되지 않았어요."
    }
}

struct MyPageViewPreview: PreviewProvider {
    static var previews: some View {
        MyPageView(cartCount: 3, onSelectTab: { _ in })
    }
}
