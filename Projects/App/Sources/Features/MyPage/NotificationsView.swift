import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel: NotificationsViewModel

    let onBack: () -> Void
    let onOpenNotification: (NotificationKind) -> Void

    init(onBack: @escaping () -> Void, onOpenNotification: @escaping (NotificationKind) -> Void) {
        self.init(onBack: onBack, onOpenNotification: onOpenNotification, viewModel: NotificationsViewModel())
    }

    init(
        onBack: @escaping () -> Void,
        onOpenNotification: @escaping (NotificationKind) -> Void,
        viewModel: NotificationsViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onOpenNotification = onOpenNotification
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            if viewModel.notifications.isEmpty {
                emptyState
            } else {
                summaryRow
                ScrollView {
                    VStack(spacing: 0) {
                        sectionHeader("오늘")
                        ForEach(viewModel.todayNotifications) { notification in
                            notificationRow(notification)
                        }
                        sectionHeader("이전 알림")
                        ForEach(viewModel.previousNotifications) { notification in
                            notificationRow(notification)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                retentionNotice
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Image("TopBarBell")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .frame(width: 64, height: 64)
                    .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 32))
                    .accessibilityHidden(true)
                Spacer().frame(height: 20)
                Text("새로운 알림이 없습니다")
                    .font(EUMTypography.heading3)
                    .tracking(-0.27)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer().frame(height: 8)
                Text("주문·배송 소식과 견적·문의 답변을\n이곳에서 알려 드립니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
                    .frame(width: 280)
                Spacer().frame(height: 24)
            }
            .padding(.top, 64)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
            .background(EUMColor.backgroundSwiftUI)
            Spacer(minLength: 0)
        }
        .padding(.top, 80)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var topBar: some View {
        ZStack {
            Text("알림")
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
                .accessibilityLabel("이전 화면으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var summaryRow: some View {
        HStack {
            Text("읽지 않은 알림 \(viewModel.unreadCount)개")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Spacer()
            Button("모두 읽음", action: viewModel.markAllRead)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(height: 36)
                .padding(.horizontal, 12)
                .contentShape(Rectangle())
                .accessibilityHint("읽지 않은 알림을 모두 읽음 처리합니다")
        }
        .padding(.leading, 20)
        .padding(.trailing, 12)
        .padding(.vertical, 8)
        .overlay(alignment: .bottom) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private func notificationRow(_ notification: AppNotification) -> some View {
        let titleFont = notification.isUnread
            ? Font.custom("NotoSansKR-Bold", size: 14, relativeTo: .callout)
            : EUMTypography.bodySmall
        return Button {
            viewModel.markRead(notification.id)
            onOpenNotification(notification.kind)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(notification.kind.iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .frame(width: 40, height: 40)
                    .background(EUMColor.surfaceSwiftUI, in: Circle())
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(notification.kind.title)
                            .font(EUMTypography.captionMedium)
                        Text(notification.time)
                            .font(EUMTypography.captionRegular)
                    }
                    .foregroundStyle(EUMColor.text3SwiftUI)

                    Text(notification.title)
                        .font(titleFont)
                        .tracking(-0.07)
                        .foregroundStyle(notification.isUnread ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(notification.message)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if notification.isUnread {
                    Image("NotificationUnreadDot")
                        .resizable()
                        .frame(width: 6, height: 12)
                        .accessibilityLabel("읽지 않음")
                } else {
                    Color.clear.frame(width: 6, height: 12)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(notification.isUnread ? EUMColor.backgroundSubtleSwiftUI : EUMColor.backgroundSwiftUI)
            .overlay(alignment: .bottom) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("읽음 처리하고 관련 내역 보기")
    }

    private var retentionNotice: some View {
        Text("최근 0일 동안의 알림만 보관합니다.")
            .font(EUMTypography.captionRegular)
            .foregroundStyle(EUMColor.text3SwiftUI)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(EUMColor.backgroundSwiftUI)
    }
}

struct NotificationsViewPreview: PreviewProvider {
    static var previews: some View {
        NotificationsView(onBack: {}, onOpenNotification: { _ in }, viewModel: NotificationsViewModel(notifications: []))
    }
}
