import SwiftUI

struct EUMSearchBar: View {
    @Binding var text: String
    var placeholder: String = "검색어를 입력해 주세요"
    var onSubmit: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            Image("DesignSearch")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .accessibilityHidden(true)

            TextField(placeholder, text: $text)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.5)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }
                .accessibilityLabel("검색어")
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(EUMColor.surfaceSwiftUI, in: Capsule())
    }
}

struct EUMSearchBarPreview: PreviewProvider {
    static var previews: some View {
        EUMSearchBar(text: .constant(""))
            .padding(20)
    }
}
