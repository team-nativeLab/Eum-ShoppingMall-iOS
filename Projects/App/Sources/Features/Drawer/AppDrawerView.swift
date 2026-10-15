import SwiftUI

struct DrawerMenuDestination: Identifiable, Equatable {
    let title: String

    var id: String { title }

    static let all = [
        DrawerMenuDestination(title: "이벤트"),
        DrawerMenuDestination(title: "맞춤 제작·견적 문의"),
        DrawerMenuDestination(title: "고객지원"),
        DrawerMenuDestination(title: "공지사항"),
        DrawerMenuDestination(title: "회사소개")
    ]
}

@MainActor
final class AppDrawerViewModel: ObservableObject {
    let brandTitle = "이음산업건설"
    let tagline = "사람이 있는 곳에, 더 안전한 내일을."
    let memberName = "홍길동님"
    let destinations = DrawerMenuDestination.all
}

struct AppDrawerView: View {
    @StateObject private var viewModel = AppDrawerViewModel()

    let onDismiss: () -> Void
    let onMyInfo: () -> Void
    let onDestination: (String) -> Void
    let onSettings: () -> Void
    let onLogout: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            EUMColor.text1SwiftUI.opacity(0.48)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)
                .accessibilityLabel("메뉴 닫기")

            drawerPanel
                .frame(width: 320)
                .frame(maxHeight: .infinity, alignment: .top)
                .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
                .shadow(color: EUMColor.text1SwiftUI.opacity(0.16), radius: 32, x: 8, y: 0)
                .accessibilityAddTraits(.isModal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .ignoresSafeArea()
        .transition(.move(edge: .leading))
    }

    private var drawerPanel: some View {
        VStack(spacing: 16) {
            brandGroup
            destinationsGroup
        }
        .padding(.top, 52)
        .padding(.bottom, 34)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var brandGroup: some View {
        VStack(spacing: 0) {
            Button(action: onDismiss) {
                Image("ProductOptionClose")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("메뉴 닫기")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.brandTitle)
                        .font(EUMTypography.heading2)
                        .tracking(-0.44)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text(viewModel.tagline)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }

                Button(action: onMyInfo) {
                    HStack {
                        Text(viewModel.memberName)
                            .font(EUMTypography.labelLarge)
                            .tracking(-0.16)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        Spacer(minLength: 8)
                        HStack(spacing: 2) {
                            Text("내 정보")
                                .font(EUMTypography.captionMedium)
                                .foregroundStyle(EUMColor.text2SwiftUI)
                            Image("MyPageChevron")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                        }
                    }
                    .padding(16)
                    .frame(height: 56)
                    .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
                    .contentShape(RoundedRectangle(cornerRadius: EUMRadius.large))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(viewModel.memberName) 내 정보")
            }
            .padding(.top, 8)
            .padding(.horizontal, EUMSpacing.homeContentInset)
        }
    }

    private var destinationsGroup: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.destinations) { destination in
                Button {
                    onDestination(destination.title)
                } label: {
                    HStack {
                        Text(destination.title)
                            .font(EUMTypography.labelLarge)
                            .tracking(-0.16)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        Spacer()
                    }
                    .padding(.horizontal, EUMSpacing.homeContentInset)
                    .frame(height: 52)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(destination.title)
            }

            Spacer(minLength: 0)
            footer
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var footer: some View {
        HStack(spacing: 8) {
            footerButton(title: "설정", icon: "MyPageSettings", action: onSettings)
            footerButton(title: "로그아웃", icon: "DrawerLogout", action: onLogout)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
        }
    }

    private func footerButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct AppDrawerViewPreview: PreviewProvider {
    static var previews: some View {
        AppDrawerView(onDismiss: {}, onMyInfo: {}, onDestination: { _ in }, onSettings: {}, onLogout: {})
    }
}
