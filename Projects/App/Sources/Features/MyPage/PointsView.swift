import SwiftUI

struct PointsView: View {
    @StateObject private var viewModel = PointsViewModel()

    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    balanceSummary
                    filters
                    history
                    usageNotice
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("적립금")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("마이페이지로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var balanceSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("사용 가능 적립금")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                Text(viewModel.availablePoints)
                    .font(Font.custom("NotoSansKR-Bold", size: 26, relativeTo: .title))
                    .tracking(-0.65)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            HStack {
                HStack(spacing: 4) {
                    Text("30일 내 소멸 예정")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                    Image("DeliveryInfo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .foregroundStyle(EUMColor.text2SwiftUI)
                Spacer()
                Text(viewModel.expiringPoints)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
        }
        .padding(20)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var filters: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(PointsHistoryFilter.allCases) { filter in
                    filterButton(filter)
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 0)
    }

    private func filterButton(_ filter: PointsHistoryFilter) -> some View {
        let isSelected = filter == viewModel.selectedFilter
        return Button {
            viewModel.selectedFilter = filter
        } label: {
            Text(filter.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background {
                    Capsule()
                        .fill(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                }
                .overlay {
                    if !isSelected {
                        Capsule().stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var history: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.filteredHistory) { item in
                PointsHistoryRow(item: item)
            }
        }
    }

    private var usageNotice: some View {
        HStack(spacing: 8) {
            Image("DeliveryInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text("적립금은 결제 시 0원 단위로 사용할 수 있습니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }
}

private struct PointsHistoryRow: View {
    let item: PointsHistoryItem

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text(item.date)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.amount)
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(item.kind == .used || item.kind == .expired ? EUMColor.text2SwiftUI : EUMColor.text1SwiftUI)
                if let expiration = item.expiration {
                    Text(expiration)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
            }
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

struct PointsViewPreview: PreviewProvider {
    static var previews: some View {
        PointsView(onBack: {})
    }
}
