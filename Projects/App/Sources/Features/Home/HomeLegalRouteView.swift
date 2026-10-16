import SwiftUI

struct HomeLegalRouteView: View {
    struct Actions {
        let back: () -> Void
        let backToSettings: () -> Void
        let login: () -> Void
        let openTerms: () -> Void
        let openPrivacyPolicy: () -> Void
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
                        actions.openTerms()
                    } else if destination == "개인정보처리방침" {
                        actions.openPrivacyPolicy()
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
                onBack: actions.backToSettings,
                onVersionTap: { actions.message("약관 버전 선택 화면은 후속 퍼블리싱 이슈에서 연결됩니다.") }
            )
        case .termsPrevious:
            TermsView(
                version: .previous,
                onBack: actions.backToSettings,
                onVersionTap: { actions.message("약관 버전 선택 화면은 후속 퍼블리싱 이슈에서 연결됩니다.") }
            )
        case .privacyPolicy:
            PrivacyPolicyView(onBack: actions.backToSettings)
        default:
            EmptyView()
        }
    }
}
