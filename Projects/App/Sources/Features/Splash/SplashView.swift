import SwiftUI

struct SplashView: View {
    let viewModel: SplashViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("SplashBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                LinearGradient(
                    stops: [
                        .init(color: Color.black.opacity(0.15), location: 0),
                        .init(color: Color.black.opacity(0.25), location: 0.45),
                        .init(color: Color.black.opacity(0.5), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(spacing: 0) {
                    SplashStatusBar()

                    VStack(alignment: .leading, spacing: 0) {
                        brand
                        Spacer(minLength: 24)
                        overline
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 256)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    SplashHomeIndicator()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .statusBarHidden()
        .accessibilityElement(children: .contain)
    }

    private var brand: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.brandName)
                        .font(EUMTypography.displayLarge)
                .tracking(-0.66)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.brandMessages, id: \.self) { message in
                    Text(message)
                        .font(EUMTypography.bodyExtraLarge)
                        .lineSpacing(9)
                }
            }
        }
        .foregroundStyle(.white)
    }

    private var overline: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.overlineMessages, id: \.self) { message in
                Text(message)
                    .font(EUMTypography.overline)
                    .tracking(1.76)
                    .lineSpacing(0)
            }
        }
        .foregroundStyle(.white)
        .accessibilityLabel(viewModel.overlineMessages.joined(separator: " "))
    }
}

private struct SplashStatusBar: View {
    var body: some View {
        HStack {
            Text("9:41")
                .font(EUMTypography.labelLarge)
                .tracking(-0.08)

            Spacer()

            HStack(alignment: .center, spacing: 6) {
                HStack(alignment: .bottom, spacing: 2) {
                    ForEach(1...4, id: \.self) { level in
                        Capsule()
                            .fill(.white)
                            .frame(width: 3, height: CGFloat(level) * 2.5 + 1.5)
                    }
                }

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 25, height: 12)
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(.white)
                        .frame(width: 19, height: 8)
                        .padding(.leading, 2)
                }
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 24)
        .frame(height: 44)
        .accessibilityHidden(true)
    }
}

private struct SplashHomeIndicator: View {
    var body: some View {
        Capsule()
            .fill(.white)
            .frame(width: 134, height: 5)
            .frame(maxWidth: .infinity)
            .frame(height: 34, alignment: .bottom)
            .padding(.bottom, 8)
            .accessibilityHidden(true)
    }
}
