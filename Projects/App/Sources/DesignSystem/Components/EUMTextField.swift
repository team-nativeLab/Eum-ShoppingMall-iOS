import SwiftUI

struct EUMTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var trailingSymbol: String?
    var isSecure = false
    var isDisabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.5)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                field
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.5)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .disabled(isDisabled)

                if let trailingSymbol {
                    Image(systemName: trailingSymbol)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .accessibilityHidden(true)
                }
            }
            // HF/TextField uses border-box sizing: 1 pt border + 14 pt padding.
            .padding(.horizontal, 15)
            .frame(height: 48)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .strokeBorder(Color(uiColor: EUMColor.text3), lineWidth: 1)
            }
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var field: some View {
        // HF/TextField placeholders use text-3 rather than the system placeholder color.
        let prompt = Text(placeholder).foregroundColor(EUMColor.text3SwiftUI)
        if isSecure {
            SecureField(placeholder, text: $text, prompt: prompt)
                .accessibilityLabel(title)
        } else {
            TextField(placeholder, text: $text, prompt: prompt)
                .accessibilityLabel(title)
        }
    }
}

struct EUMTextFieldPreview: PreviewProvider {
    static var previews: some View {
        EUMTextField(title: "이름", placeholder: "이름을 입력해 주세요", text: .constant(""))
            .padding(20)
    }
}
