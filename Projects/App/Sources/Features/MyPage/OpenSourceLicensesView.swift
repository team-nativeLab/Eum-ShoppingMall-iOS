import SwiftUI

struct OpenSourceLicensesView: View {
    let onBack: () -> Void

    private let licenses = [
        LicenseItem(name: "AndroidX · 예시", license: "Apache License 2.0"),
        LicenseItem(name: "Kotlin · 예시", license: "Apache License 2.0"),
        LicenseItem(name: "Coil · 예시", license: "Apache License 2.0"),
        LicenseItem(name: "OkHttp · 예시", license: "Apache License 2.0")
    ]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("목록 예시입니다. 실제 포함 라이브러리는 앱 구성에 따라 표시됩니다.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)

                    LazyVStack(spacing: 8) {
                        ForEach(licenses) { item in
                            LicenseCard(item: item)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "오픈소스 라이선스",
            backAccessibilityLabel: "뒤로 가기",
            backAccessibilityIdentifier: "open-source-licenses-back",
            onBack: onBack
        ) {
            Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
        }
    }
}

private struct LicenseItem: Identifiable {
    let name: String
    let license: String

    var id: String { name }
}

private struct LicenseCard: View {
    let item: LicenseItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "shippingbox")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color(red: 10 / 255, green: 110 / 255, blue: 87 / 255))
                .frame(width: 36, height: 36)
                .background(Color(red: 231 / 255, green: 245 / 255, blue: 241 / 255), in: RoundedRectangle(cornerRadius: 11))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text(item.license)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 13)
        .frame(minHeight: 56)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}
