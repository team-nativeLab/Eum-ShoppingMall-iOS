import SwiftUI

struct SettingsGroup<Content: View, Footer: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    let footer: Footer

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        self.footer = footer()
    }

    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) where Footer == EmptyView {
        self.init(title: title, subtitle: subtitle, content: content, footer: { EmptyView() })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                if let subtitle {
                    Text(subtitle)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            content
                .padding(1)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.large)
                        .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                }

            footer
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingsToggleRow: View {
    let title: String
    var subtitle: String?
    @Binding var isOn: Bool
    var showsDivider = false

    init(title: String, subtitle: String? = nil, isOn: Binding<Bool>, showsDivider: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        _isOn = isOn
        self.showsDivider = showsDivider
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("NotoSansKR-Regular", size: 16, relativeTo: .body))
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let subtitle {
                    Text(subtitle)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(height: subtitle == nil ? 26 : 44, alignment: .center)
        }
        .toggleStyle(SettingsSwitchToggleStyle(title: title))
        .frame(height: subtitle == nil ? 60 : 72)
        .overlay(alignment: .bottom) {
            if showsDivider {
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
    }
}

private struct SettingsSwitchToggleStyle: ToggleStyle {
    let title: String

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                configuration.label
                Spacer(minLength: 0)
                Image(configuration.isOn ? "SettingsSwitchOn" : "SettingsSwitchOff")
                    .resizable()
                    .frame(width: 36, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(configuration.isOn ? "켜짐" : "꺼짐")
        .accessibilityHint("두 번 탭하여 변경")
    }
}

struct SettingsNavigationRow: View {
    let title: String
    var showsDivider = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.custom("NotoSansKR-Regular", size: 16, relativeTo: .body))
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("SettingsMenuChevron")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .overlay(alignment: .bottom) {
            if showsDivider {
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
    }
}
