import SwiftUI

struct AnnouncementsView: View {
    let viewModel: AnnouncementsViewModel
    let onBack: () -> Void
    let onOpenAnnouncement: (AnnouncementItem) -> Void

    init(
        viewModel: AnnouncementsViewModel = AnnouncementsViewModel(),
        onBack: @escaping () -> Void,
        onOpenAnnouncement: @escaping (AnnouncementItem) -> Void
    ) {
        self.viewModel = viewModel
        self.onBack = onBack
        self.onOpenAnnouncement = onOpenAnnouncement
    }

    var body: some View {
        Group {
            if viewModel.isEmpty {
                AnnouncementsEmptyView(onBack: onBack)
            } else {
                VStack(spacing: 0) {
                    topBar
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.announcements) { announcement in
                                announcementRow(announcement)
                            }
                            ProgressView()
                                .tint(EUMColor.text3SwiftUI)
                                .frame(maxWidth: .infinity)
                                .frame(height: 64)
                                .accessibilityLabel("공지사항을 불러오는 중")
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
            }
        }
    }

    private var topBar: some View {
        ZStack {
            Text("공지사항")
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
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    @ViewBuilder
    private func announcementRow(_ announcement: AnnouncementItem) -> some View {
        let content = VStack(alignment: .leading, spacing: 8) {
            if announcement.isPinned {
                Text("공지")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.inverseSwiftUI)
                    .padding(.horizontal, 6)
                    .frame(height: 20)
                    .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 4))
            }
            Text(announcement.title)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(announcement.date)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(announcement.isPinned ? EUMColor.backgroundSubtleSwiftUI : EUMColor.backgroundSwiftUI)
        .overlay(alignment: .bottom) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }

        if announcement.opensDetail {
            Button { onOpenAnnouncement(announcement) } label: { content }
                .buttonStyle(.plain)
                .accessibilityHint("공지사항 상세 내용을 봅니다")
        } else {
            content
        }
    }
}
