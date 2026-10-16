import SwiftUI

struct AnnouncementsEmptyView: View {
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            emptyState
            Spacer(minLength: 0)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
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

    private var emptyState: some View {
        VStack(spacing: 0) {
            Image("AnnouncementsEmptyIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .frame(width: 64, height: 64)
                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 32))
                .accessibilityHidden(true)

            Spacer().frame(height: 20)

            Text("등록된 공지사항이 없습니다")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 120)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity)
        .background(EUMColor.backgroundSwiftUI)
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
    }
}

struct AnnouncementsEmptyViewPreview: PreviewProvider {
    static var previews: some View {
        AnnouncementsEmptyView(onBack: {})
    }
}
