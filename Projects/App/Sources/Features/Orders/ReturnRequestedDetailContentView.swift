import SwiftUI

struct ReturnRequestedDetailContentView: View {
    let item: ReturnHistoryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("반품 신청")
                .font(EUMTypography.heading3)
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

    // Figma A-51: white bordered cards (r12, 14/16 insets) with icon rows.
    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image("ReturnDetailCheck")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
                Text("신청 접수")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.successSwiftUI)
            }
            Text("담당자가 신청 내용을 확인한 뒤 처리합니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .eumCardBackground()
    }

    private var productCard: some View {
        HStack(spacing: 12) {
            Image("ReturnCompletionPackage")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("신청 상품")
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255))
                Text("\(item.productName) / \(item.priceAndQuantity)")
                    .font(EUMTypography.bodyMedium)
                    .foregroundStyle(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .eumCardBackground()
        .accessibilityElement(children: .combine)
    }

    private var requestInformationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("신청 정보")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            ReturnSummaryRow(icon: "ReturnCompletionCalendar", title: "신청일", value: item.requestDate)
            ReturnSummaryRow(icon: "ReturnDetailReason", title: "신청 사유", value: item.requestReason)
            ReturnSummaryRow(icon: "ReturnDetailPin", title: "회수 주소", value: item.pickupAddress)
            ReturnSummaryRow(icon: "ReturnCompletionReceipt", title: "신청 번호", value: item.applicationNumber)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .eumCardBackground()
    }
}
