import SwiftUI

struct HomeLegalRouteView: View {
    struct Actions {
        let back: () -> Void
        let login: () -> Void
        let onRoute: (HomeModalRoute) -> Void
        let message: (String) -> Void
        let logout: () -> Void
        let withdrawal: () -> Void
    }

    let route: HomeModalRoute
    let isGuestAccount: Bool
    let actions: Actions

    @ViewBuilder
    var body: some View {
        switch route {
        case .settings:
            SettingsView(
                isGuestAccount: isGuestAccount,
                onBack: actions.back,
                onLoginTap: actions.login,
                onPolicyTap: { destination in
                    if destination == "이용약관" {
                        actions.onRoute(.terms)
                    } else if destination == "개인정보처리방침" {
                        actions.onRoute(.privacyPolicy)
                    } else if destination == "이용안내" {
                        actions.onRoute(.usageGuide)
                    } else {
                        actions.message("\(destination) 화면은 후속 퍼블리싱 이슈에서 연결됩니다.")
                    }
                },
                onLogoutTap: actions.logout,
                onWithdrawalTap: actions.withdrawal
            )
        case .terms:
            TermsView(
                version: .revisionScheduled,
                onBack: actions.back
            )
        case .privacyPolicy:
            PrivacyPolicyView(onBack: actions.back)
        case .usageGuide:
            UsageGuideView(
                onBack: actions.back,
                onCustomerCenterTap: { actions.onRoute(.customerCenter) }
            )
        default:
            EmptyView()
        }
    }
}

struct HomeLegalRouteContainer: View {
    let route: HomeModalRoute
    let isGuestAccount: Bool
    let back: () -> Void
    let login: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let message: (String) -> Void
    let logout: () -> Void
    let withdrawal: () -> Void

    var body: some View {
        HomeLegalRouteView(
            route: route,
            isGuestAccount: isGuestAccount,
            actions: HomeLegalRouteView.Actions(
                back: back,
                login: login,
                onRoute: onRoute,
                message: message,
                logout: logout,
                withdrawal: withdrawal
            )
        )
    }
}
