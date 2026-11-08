import SwiftUI

struct EventItem: Identifiable, Equatable {
    let id: String
    let status: String
    let title: String
    let period: String
    let iconName: String
    let isFeatured: Bool

    static let samples = [
        EventItem(
            id: "event-ongoing-1",
            status: "진행 중",
            title: "현장 안전용품 특별 기획전",
            period: "10.01–10.31",
            iconName: "gift",
            isFeatured: true
        ),
        EventItem(
            id: "event-ongoing-2",
            status: "진행 중",
            title: "가을맞이 안전장비 할인",
            period: "10.10–10.31",
            iconName: "calendar",
            isFeatured: false
        ),
        EventItem(
            id: "event-ended-1",
            status: "종료",
            title: "신규 회원 웰컴 혜택",
            period: "09.01–09.30",
            iconName: "clock",
            isFeatured: false
        )
    ]
}

struct EventsView: View {
    let onBack: () -> Void
    let onOpenEvent: (EventItem) -> Void
    private let items: [EventItem]

    init(
        items: [EventItem] = EventItem.samples,
        onBack: @escaping () -> Void,
        onOpenEvent: @escaping (EventItem) -> Void
    ) {
        self.items = items
        self.onBack = onBack
        self.onOpenEvent = onOpenEvent
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

            if items.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        Text("진행 중인 이벤트와 지난 혜택을 확인해 보세요.")
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text3SwiftUI)

                        LazyVStack(spacing: 12) {
                            ForEach(items) { event in
                                eventRow(event)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
    }

    @ViewBuilder
    private func eventRow(_ event: EventItem) -> some View {
        let card = EventInfoCard(
            title: event.status,
            detail: "\(event.title) · \(event.period)",
            iconName: event.iconName,
            showsChevron: event.isFeatured
        )

        if event.isFeatured {
            Button {
                onOpenEvent(event)
            } label: {
                card
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("event-open-\(event.id)")
        } else {
            card
        }
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 120)
    }
}

struct EventDetailView: View {
    let event: EventItem
    let onBack: () -> Void
    let onBrowseProducts: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: event.title,
                backAccessibilityLabel: "이벤트 목록으로 돌아가기",
                backAccessibilityIdentifier: "event-detail-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    Text("이벤트 기간 · 2026.\(event.period)")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)

                    VStack(spacing: 12) {
                        EventInfoCard(
                            title: "혜택 안내",
                            detail: "안전용품을 한곳에서 확인하세요.",
                            iconName: "gift"
                        )
                        EventInfoCard(
                            title: "참여 방법",
                            detail: "기획전 상품을 확인하고 주문을 진행해 주세요.",
                            iconName: "info.circle"
                        )
                        EventInfoCard(
                            title: "유의 사항",
                            detail: "혜택과 적용 조건은 상품 상세에서 확인해 주세요.",
                            iconName: "exclamationmark.circle",
                            showsChevron: true
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            EUMButton(title: "상품 보러 가기", size: .large, action: onBrowseProducts)
                .accessibilityIdentifier("event-browse-products")
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(EUMColor.backgroundSwiftUI)
        }
    }
}

private struct EventInfoCard: View {
    let title: String
    let detail: String
    let iconName: String
    var showsChevron = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(red: 10 / 255, green: 110 / 255, blue: 87 / 255))
                .frame(width: 36, height: 36)
                .background(Color(red: 231 / 255, green: 245 / 255, blue: 241 / 255), in: RoundedRectangle(cornerRadius: 11))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text(detail)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if showsChevron {
                Image("SectionChevron")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
        }
        .padding(.horizontal, 13)
        .frame(height: 80)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}
