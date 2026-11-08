import SwiftUI
import UIKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var isShowingLogoutConfirmation = false
    @Environment(\.scenePhase) private var scenePhase

    let isGuestAccount: Bool
    let onBack: () -> Void
    let onLoginTap: () -> Void
    let onPolicyTap: (String) -> Void
    let onLogoutTap: () -> Void
    let onWithdrawalTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    notificationGroup
                    if isGuestAccount {
                        guestMarketingGroup
                    } else {
                        marketingGroup
                    }
                    policyGroup
                    appInfoGroup
                    if !isGuestAccount {
                        accountGroup
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .task {
            guard !isGuestAccount else { return }
            await viewModel.refreshDeviceNotificationAuthorization()
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active, !isGuestAccount else { return }
            Task { await viewModel.refreshDeviceNotificationAuthorization() }
        }
        .overlay(alignment: .bottom) {
            if let message = viewModel.marketingChangeToast {
                SettingsMarketingToast(message: message)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.2), value: viewModel.marketingChangeToast != nil)
        .onDisappear { viewModel.dismissMarketingToast() }
        .overlay {
            if isShowingLogoutConfirmation {
                ZStack {
                    EUMColor.text1SwiftUI.opacity(0.48)
                        .ignoresSafeArea()
                    LogoutConfirmationDialog(
                        onCancel: { isShowingLogoutConfirmation = false },
                        onConfirm: {
                            isShowingLogoutConfirmation = false
                            onLogoutTap()
                        }
                    )
                }
                .transition(.opacity)
                .zIndex(2)
            }
        }
        .animation(.easeOut(duration: 0.2), value: isShowingLogoutConfirmation)
    }

    private var notificationGroup: some View {
        SettingsGroup(title: "알림") {
            SettingsToggleRow(
                title: "앱 푸시 알림",
                subtitle: "주문·배송, 견적·문의 답변 알림",
                isOn: appPushBinding,
                isEnabled: isGuestAccount || viewModel.deviceNotificationsAllowed
            )
        } footer: {
            if !isGuestAccount && !viewModel.deviceNotificationsAllowed {
                SettingsDeviceNotificationNotice(onOpenSettings: openDeviceSettings)
            }
        }
    }

    private var appPushBinding: Binding<Bool> {
        Binding(
            get: { viewModel.appPushEnabled && (isGuestAccount || viewModel.deviceNotificationsAllowed) },
            set: { viewModel.appPushEnabled = $0 }
        )
    }

    private func marketingBinding(for channel: SettingsViewModel.MarketingChannel) -> Binding<Bool> {
        Binding(
            get: { viewModel.marketingSetting(for: channel) },
            set: { viewModel.setMarketingSetting($0, for: channel) }
        )
    }

    private var marketingGroup: some View {
        SettingsGroup(
            title: "마케팅 정보 수신",
            subtitle: "혜택·이벤트 소식을 보내 드립니다. 변경하면 처리 결과를 알려 드립니다."
        ) {
            VStack(spacing: 0) {
                SettingsToggleRow(title: "앱 푸시", isOn: marketingBinding(for: .appPush), showsDivider: true)
                SettingsToggleRow(title: "문자(SMS)", isOn: marketingBinding(for: .sms), showsDivider: true)
                SettingsToggleRow(title: "이메일", isOn: marketingBinding(for: .email), showsDivider: true)
                SettingsToggleRow(
                    title: "야간 혜택 알림 (21시~8시)",
                    subtitle: "마케팅 앱 푸시를 켜야 받을 수 있습니다.",
                    isOn: marketingBinding(for: .nightBenefits)
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

    private var guestMarketingGroup: some View {
        SettingsGroup(title: "마케팅 정보 수신", cardStyle: .subtle) {
            VStack(alignment: .leading, spacing: 12) {
                Text("로그인하면 마케팅 정보 수신 설정을 변경할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
                EUMButton(title: "로그인", kind: .secondary, size: .small, action: onLoginTap)
                    .frame(width: 65)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
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
            SettingsNavigationRow(title: "로그아웃") {
                isShowingLogoutConfirmation = true
            }
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

    private func openDeviceSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

enum SettingsPolicyDestination {
    static let all = ["이용약관", "개인정보처리방침", "이용안내", "오픈소스 라이선스"]
}
