import SwiftUI

struct ReturnRequestedDetailContentView: View {
    let item: ReturnHistoryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("반품 신청")
                .font(EUMTypography.heading2)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            statusCard
            productCard
            requestInformationCard
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }

    private var statusCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(Color(red: 0.12, green: 0.58, blue: 0.48))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("신청 접수")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("담당자가 신청 내용을 확인한 뒤 처리합니다.")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.91, green: 0.96, blue: 0.94), in: RoundedRectangle(cornerRadius: 12))
    }

    private var productCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("신청 상품")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack(spacing: 12) {
                ZStack {
                    EUMColor.imagePlaceholderTopSwiftUI
                    Image("ProductPlaceholder")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .accessibilityHidden(true)
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.productName)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text(item.priceAndQuantity)
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var requestInformationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("신청 정보")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            informationRow("신청일", value: item.requestDate)
            informationRow("신청 사유", value: item.requestReason)
            informationRow("회수 주소", value: item.pickupAddress)
            informationRow("신청 번호", value: item.applicationNumber)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func informationRow(_ title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Spacer(minLength: 8)
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(EUMTypography.bodySmall)
    }
}
