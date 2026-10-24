import SwiftUI

struct ReturnRejectionReasonView: View {
    let item: ReturnHistoryItem
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Text("‹").font(.system(size: 26)).frame(width: 32, height: 44)
                }
                .accessibilityLabel("이전 화면으로 돌아가기")
                Text("반려 사유").font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            .foregroundStyle(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255))
            .padding(.horizontal, 20)
            .frame(height: 56)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("신청 처리 결과")
                        .font(.system(size: 13))
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(height: 58, alignment: .topLeading)
                    card("진행 상태", value: "반려 · 신청이 처리되지 않았습니다.", icon: "RejectionStatus")
                    card("신청 상품", value: "\(item.productName) · \(item.priceAndQuantity)", icon: "RejectionProduct")
                    card("반려 사유", value: item.rejectionReason ?? "반려 사유는 신청 내역에서 확인해 주세요.", icon: "RejectionReason")
                    card("신청 번호", value: "신청 내역에서 확인", icon: "RejectionNumber")
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
            }
            .scrollIndicators(.hidden)
            Button(action: onBack) {
                Text("신청 내역 보기")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255),
                                in: RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
    }

    private func card(_ title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
                .frame(width: 36, height: 36)
                .background(Color(red: 231 / 255, green: 245 / 255, blue: 241 / 255),
                            in: RoundedRectangle(cornerRadius: 11))
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255))
                Text(value).font(.system(size: 13)).foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}
