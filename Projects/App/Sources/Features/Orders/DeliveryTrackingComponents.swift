import SwiftUI

struct DeliveryProgressView: View {
    let steps: [String]
    let currentStepIndex: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                progressTrack(width: geometry.size.width)
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, title in
                        step(index: index, title: title)
                        if index < steps.count - 1 {
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
        }
        .frame(height: 40)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("배송 진행 상태, 현재 \(steps[currentStepIndex])")
    }

    private func progressTrack(width: CGFloat) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 32, y: 10))
            path.addLine(to: CGPoint(x: width - 32, y: 10))
        }
        .stroke(EUMColor.lineStrongSwiftUI, lineWidth: 2)
        .overlay(alignment: .topLeading) {
            Path { path in
                let centers = stepCenters(width: width)
                path.move(to: CGPoint(x: centers[0], y: 10))
                path.addLine(to: CGPoint(x: centers[currentStepIndex], y: 10))
            }
            .stroke(EUMColor.text1SwiftUI, lineWidth: 2)
        }
    }

    private func stepCenters(width: CGFloat) -> [CGFloat] {
        let gap = (width - CGFloat(steps.count * 64)) / CGFloat(max(steps.count - 1, 1))
        return steps.indices.map { 32 + CGFloat($0) * (64 + gap) }
    }

    private func step(index: Int, title: String) -> some View {
        VStack(spacing: 6) {
            ZStack {
                if index < currentStepIndex {
                    Circle()
                        .fill(EUMColor.text1SwiftUI)
                    Image("DeliveryProgressCheck")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                } else if index == currentStepIndex {
                    Circle().fill(EUMColor.text1SwiftUI)
                } else {
                    Circle()
                        .fill(EUMColor.backgroundSwiftUI)
                        .overlay(Circle().stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                }
            }
            .frame(width: 20, height: 20)

            Text(title)
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(index == steps.count - 1 ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(width: 64)
        }
        .frame(width: 64)
        .accessibilityLabel("\(title)\(index == currentStepIndex ? ", 현재 단계" : "")")
    }
}

struct DeliveryTimelineView: View {
    let events: [DeliveryTrackingEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("배송 상세")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    timelineRow(event, isCurrent: index == 0)
                }
            }
        }
    }

    private func timelineRow(_ event: DeliveryTrackingEvent, isCurrent: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(isCurrent ? "DeliveryTimelineActive" : "DeliveryTimelineInactive")
                .resizable()
                .frame(width: isCurrent ? 10 : 8, height: isCurrent ? 59 : 57)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text(event.locationAndDate)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

struct DeliveryProgressViewPreview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            DeliveryProgressView(steps: ["결제완료", "상품준비", "배송시작", "배송중", "배송완료"], currentStepIndex: 3)
            DeliveryTimelineView(events: DeliveryTrackingViewModel(order: OrderHistoryItem.samples[2]).events)
        }
        .padding(20)
    }
}
