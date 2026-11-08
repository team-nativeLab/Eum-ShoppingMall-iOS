import SwiftUI

struct AnnouncementDetailView: View {
    let announcement: AnnouncementItem
    let onBack: () -> Void
    let onDownload: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    articleHeader
                    Rectangle()
                        .fill(EUMColor.lineSwiftUI)
                        .frame(height: 1)
                    Text(announcement.bodyText)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .lineSpacing(0)
                        .fixedSize(horizontal: false, vertical: true)
                    placeholderImage
                    attachmentCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
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
                .accessibilityLabel("공지사항 목록으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var articleHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("공지")
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 4))

            Text(announcement.title)
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)

            Text("\(announcement.date) · 조회 \(announcement.viewCount)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var placeholderImage: some View {
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
        .aspectRatio(350.0 / 197.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .accessibilityLabel("공지 이미지 자리표시자")
    }

    private var attachmentCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("첨부파일 1")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Image("QuoteDetailAttachment")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)

                Text(announcement.attachmentName)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(announcement.attachmentSize)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .fixedSize()

                Button {
                    onDownload(announcement.attachmentName)
                } label: {
                    Image("QuoteDetailDownload")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("첨부 파일 \(announcement.attachmentName) 다운로드")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }
}
