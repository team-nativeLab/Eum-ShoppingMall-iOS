import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    let onBack: () -> Void
    let onPolicyTap: (String) -> Void
    let onLogoutTap: () -> Void
    let onWithdrawalTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    notificationGroup
                    marketingGroup
                    policyGroup
                    appInfoGroup
                    accountGroup
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var notificationGroup: some View {
        SettingsGroup(title: "알림") {
            SettingsToggleRow(
                title: "앱 푸시 알림",
                subtitle: "주문·배송, 견적·문의 답변 알림",
                isOn: $viewModel.appPushEnabled
            )
        }
    }

    private var marketingGroup: some View {
        SettingsGroup(
            title: "마케팅 정보 수신",
            subtitle: "혜택·이벤트 소식을 보내 드립니다. 변경하면 처리 결과를 알려 드립니다."
        ) {
            VStack(spacing: 0) {
                SettingsToggleRow(title: "앱 푸시", isOn: $viewModel.marketingAppPushEnabled, showsDivider: true)
                SettingsToggleRow(title: "문자(SMS)", isOn: $viewModel.marketingSMSEnabled, showsDivider: true)
                SettingsToggleRow(title: "이메일", isOn: $viewModel.marketingEmailEnabled, showsDivider: true)
                SettingsToggleRow(
                    title: "야간 혜택 알림 (21시~8시)",
                    subtitle: "마케팅 앱 푸시를 켜야 받을 수 있습니다.",
                    isOn: $viewModel.nightMarketingEnabled
                )
            }
        } footer: {
            Text("최종 변경 \(viewModel.lastUpdatedDate)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
        }
    }

    private var policyGroup: some View {
        SettingsGroup(title: "약관 및 정책") {
            VStack(spacing: 0) {
                ForEach(SettingsPolicyDestination.all.indices, id: \.self) { index in
                    let destination = SettingsPolicyDestination.all[index]
                    SettingsNavigationRow(
                        title: destination,
                        showsDivider: index < SettingsPolicyDestination.all.count - 1,
                        action: { onPolicyTap(destination) }
                    )
                }
            }
        }
    }

    private var appInfoGroup: some View {
        SettingsGroup(title: "앱 정보") {
            HStack(spacing: 8) {
                Text("앱 버전")
                    .font(.custom("NotoSansKR-Regular", size: 16, relativeTo: .body))
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 0)
                Text(viewModel.appVersion)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
        }
    }

    private var accountGroup: some View {
        SettingsGroup(title: "계정") {
            SettingsNavigationRow(title: "로그아웃", action: onLogoutTap)
        } footer: {
            Button(action: onWithdrawalTap) {
                Text("회원 탈퇴")
                    .font(EUMTypography.captionRegular)
                    .underline()
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 16)
            }
            .buttonStyle(.plain)
            .padding(.top, 12)
            .accessibilityLabel("회원 탈퇴")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("설정")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("뒤로 가기")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }
}

enum SettingsPolicyDestination {
    static let all = ["이용약관", "개인정보처리방침", "이용안내", "오픈소스 라이선스"]
}
