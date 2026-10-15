import SwiftUI

struct EUMHeroBanner: View {
    struct Page: Identifiable {
        let id: String
        let eyebrow: String
        let title: String
        let subtitle: String
        var imageName: String = "HeroBannerPlaceholder"
        let actionTitle: String
        var action: () -> Void
    }

    let pages: [Page]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var currentPage = 0
    @State private var isTouching = false

    var body: some View {
        if let page = pages[safe: currentPage] {
            ZStack(alignment: .topLeading) {
                Image(page.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 224)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 0) {
                    Text(page.eyebrow.uppercased())
                        .font(EUMTypography.overline)
                        .tracking(1.76)
                        .foregroundStyle(EUMColor.inverseSecondarySwiftUI)

                    Text(page.title)
                        .font(EUMTypography.heading2)
                        .tracking(-0.44)
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                        .padding(.top, 8)

                    Text(page.subtitle)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.inverseSecondarySwiftUI)
                        .padding(.top, 6)

                    Button(action: page.action) {
                        HStack(spacing: 4) {
                            Text(page.actionTitle)
                                .font(EUMTypography.labelMedium)
                                .tracking(-0.07)
                            Image("HeroBannerArrow")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .accessibilityHidden(true)
                        }
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                        .padding(.horizontal, 16)
                        .frame(height: 36)
                        .overlay(Capsule().stroke(EUMColor.inverseSwiftUI, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 16)
                }
                .padding(24)

                if pages.count > 1 {
                    Image("HeroBannerIndicator")
                        .resizable()
                        .frame(width: 30, height: 6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, 12)
                        .accessibilityLabel("배너 \(currentPage + 1)/\(pages.count)")
                }
            }
            .frame(height: 224)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
            .contentShape(RoundedRectangle(cornerRadius: EUMRadius.large))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isTouching = true }
                    .onEnded { _ in isTouching = false }
            )
            .task(id: pages.count) {
                guard pages.count > 1 else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                    if !isTouching && !reduceMotion {
                        currentPage = (currentPage + 1) % pages.count
                    }
                }
            }
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
