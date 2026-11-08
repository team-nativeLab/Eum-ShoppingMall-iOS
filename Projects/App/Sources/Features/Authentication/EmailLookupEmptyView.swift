import SwiftUI

struct EmailLookupEmptyView: View {
    let onClose: () -> Void
    let onFindAgain: () -> Void
    let onSignUp: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            emptyState
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("계정 찾기")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("계정 찾기 닫기")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Image("SearchEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .frame(width: 64, height: 64)
                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 32))
                .accessibilityHidden(true)
            Spacer().frame(height: 20)
            Text("일치하는 회원 정보가 없습니다")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .accessibilityAddTraits(.isHeader)
            Spacer().frame(height: 8)
            Text("입력한 이름과 휴대폰 번호를 다시 확인해 주세요.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            Spacer().frame(height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 64)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var bottomActions: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            HStack(spacing: 8) {
                EUMButton(title: "다시 찾기", kind: .primary, size: .large, action: onFindAgain)
                EUMButton(title: "회원가입", kind: .secondary, size: .large, action: onSignUp)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
