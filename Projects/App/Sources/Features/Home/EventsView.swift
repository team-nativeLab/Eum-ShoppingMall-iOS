import SwiftUI

struct EventItem: Identifiable, Equatable {
    enum Status: String, CaseIterable, Identifiable {
        case ongoing = "진행중"
        case ended = "종료"

        var id: String { rawValue }
    }

    let id: String
    let title: String
    let period: String
    let status: Status

    static let samples = [
        EventItem(id: "event-ongoing-1", title: "이벤트 제목이 들어갑니다", period: "0000.00.00 - 0000.00.00", status: .ongoing),
        EventItem(id: "event-ongoing-2", title: "이벤트 제목이 들어갑니다", period: "0000.00.00 - 0000.00.00", status: .ongoing),
        EventItem(id: "event-ended-1", title: "이벤트 제목이 들어갑니다", period: "0000.00.00 - 0000.00.00", status: .ended)
    ]
}

struct EventsView: View {
    let onBack: () -> Void
    let onOpenEvent: (EventItem) -> Void
    private let items: [EventItem]

    @State private var selectedStatus = EventItem.Status.ongoing

    init(
        items: [EventItem] = EventItem.samples,
        onBack: @escaping () -> Void,
        onOpenEvent: @escaping (EventItem) -> Void
    ) {
        self.items = items
        self.onBack = onBack
        self.onOpenEvent = onOpenEvent
    }

    private var events: [EventItem] {
        items.filter { $0.status == selectedStatus }
    }

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "이벤트",
                backAccessibilityLabel: "이전 화면으로 돌아가기",
                backAccessibilityIdentifier: "events-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            statusPicker
            if events.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(events) { event in
                            eventRow(event)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            Spacer(minLength: 0)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var statusPicker: some View {
        HStack(spacing: 24) {
            ForEach(EventItem.Status.allCases) { status in
                Button {
                    selectedStatus = status
                } label: {
                    VStack(spacing: 10) {
                        Text(status.rawValue)
                            .font(EUMTypography.labelMedium)
                            .foregroundStyle(selectedStatus == status ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                        Rectangle()
                            .fill(selectedStatus == status ? EUMColor.text1SwiftUI : .clear)
                            .frame(height: 2)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selectedStatus == status ? .isSelected : [])
                .accessibilityIdentifier("events-status-\(status.id)")
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }

    @ViewBuilder
    private func eventRow(_ event: EventItem) -> some View {
        Button {
            onOpenEvent(event)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    LinearGradient(
                        colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    Image("ProductPlaceholder")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(350.0 / 180.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .lineLimit(1)
                    Text(event.period)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(event.title), \(event.period), 상세 보기")
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image("AnnouncementsEmptyIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .frame(width: 64, height: 64)
                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 32))
                .accessibilityHidden(true)
            Text("등록된 이벤트가 없습니다")
                .font(EUMTypography.heading3)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
    }
}

struct EventDetailView: View {
    let event: EventItem
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "이벤트",
                backAccessibilityLabel: "이벤트 목록으로 돌아가기",
                backAccessibilityIdentifier: "event-detail-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.status.rawValue)
                            .font(EUMTypography.captionMedium)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                        Text(event.title)
                            .font(EUMTypography.heading3)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(event.period)
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                    }
                    Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                    Text("이벤트 내용이 들어갑니다.")
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                    Text("이벤트 상품과 참여 방법은 운영 정보를 연결한 뒤 확인할 수 있습니다.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(.hidden)
            Spacer(minLength: 0)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }
}
