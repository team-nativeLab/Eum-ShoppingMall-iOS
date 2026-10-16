import SwiftUI

struct CustomerCenterContactCard: View {
    let viewModel: CustomerCenterViewModel
    let onCall: () -> Void
    let onContact: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("고객센터")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(minHeight: 16)

            Text(viewModel.phoneNumber)
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(minHeight: 30)

            Text(viewModel.operatingHours)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(minHeight: 16)

            HStack(spacing: 8) {
                EUMButton(title: "전화 걸기", kind: .secondary, size: .medium, action: onCall)
                EUMButton(title: "1:1 문의하기", kind: .primary, size: .medium, action: onContact)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }
}
