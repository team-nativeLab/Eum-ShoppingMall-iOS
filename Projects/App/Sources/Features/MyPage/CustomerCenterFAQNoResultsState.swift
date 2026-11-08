import SwiftUI

struct CustomerCenterFAQNoResultsState: View {
    let query: String
    let onContact: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image("SearchEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .frame(width: 64, height: 64)
                .background(EUMColor.surfaceSwiftUI, in: Circle())
                .accessibilityHidden(true)

            Spacer().frame(height: 20)

            Text("‘\(query)’에 대한 답변을 찾지 못했습니다")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(minHeight: 26)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Spacer().frame(height: 8)

            Text("다른 단어로 검색하거나 1:1 문의를 남겨 주세요.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(width: 280)
                .frame(minHeight: 20)
                .multilineTextAlignment(.center)

            Spacer().frame(height: 24)

            EUMButton(title: "1:1 문의하기", kind: .secondary, size: .medium, action: onContact)
                .frame(width: 160)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(EUMColor.backgroundSwiftUI)
    }
}
