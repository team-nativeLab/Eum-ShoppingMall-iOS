import SwiftUI

struct ReturnRequestCompletionView: View {
    let item: ReturnHistoryItem
    let onBack: () -> Void
    let onViewHistory: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            VStack(alignment: .leading, spacing: 20) {
                Text("신청 내역에서 진행 상태를 확인할 수 있습니다.")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(Color(red: 102 / 255, green: 102 / 255, blue: 102 / 255))
                    .padding(.top, 18)
                valueField(title: "접수 번호", value: item.applicationNumber)
                valueField(title: "안내", value: "담당자가 확인 후 처리합니다.")
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button(action: onViewHistory) {
                Text("신청 내역 보기")
                    .font(.custom("NotoSansKR-Bold", size: 15))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                    .padding(.horizontal, 12)
                    .background(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255),
                                in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("return-request-completion-history")
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(AccountEmptyState.background)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Image("RequestBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 32, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("신청 화면으로 돌아가기")
            .accessibilityIdentifier("return-request-completion-back")
            Text("신청이 접수됐어요")
                .font(.custom("NotoSansKR-Bold", size: 18))
                .foregroundStyle(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(AccountEmptyState.background)
    }

    private func valueField(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("NotoSansKR-Bold", size: 13))
                .foregroundStyle(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255))
            Text(value)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(Color(red: 31 / 255, green: 33 / 255, blue: 38 / 255))
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(.horizontal, 13)
                .background(.white, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        }
    }
}

struct ReturnWithdrawalCompletionView: View {
    let item: ReturnHistoryItem
    let onViewHistory: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("신청 철회 완료")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(Color(red: 23 / 255, green: 23 / 255, blue: 23 / 255))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Image("ReturnCompletionCheck")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .frame(width: 64, height: 64)
                        .background(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255), in: Circle())
                        .frame(maxWidth: .infinity)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("철회가 완료됐어요")
                            .font(.custom("NotoSansKR-Bold", size: 18))
                            .tracking(-0.27)
                            .foregroundStyle(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                        Text("\(item.applicationNumber) \(item.kind.rawValue) 신청을 철회했습니다. 신청 내역에서 상태를 확인할 수 있습니다.")
                            .font(EUMTypography.bodyMedium)
                            .tracking(-0.075)
                            .foregroundStyle(Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    summaryCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button(action: onViewHistory) {
                Text("신청 내역 보기")
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255),
                                in: RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("return-withdrawal-completion-history")
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .background(.white)
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("철회된 신청")
                .font(.custom("NotoSansKR-Medium", size: 16))
                .tracking(-0.08)
                .foregroundStyle(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                .padding(.bottom, 2)
            summaryRow(icon: "ReturnCompletionReceipt", title: "신청 종류", value: "\(item.kind.rawValue) 신청")
            summaryRow(icon: "ReturnCompletionPackage", title: "신청 상품", value: "\(item.productName) · \(item.priceAndQuantity)")
            summaryRow(icon: "ReturnCompletionReceipt", title: "신청 번호", value: item.applicationNumber)
            summaryRow(icon: "ReturnCompletionCalendar", title: "신청일", value: item.requestDate)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func summaryRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(title)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(Color(red: 85 / 255, green: 85 / 255, blue: 85 / 255))
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}
