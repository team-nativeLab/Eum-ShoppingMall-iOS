import SwiftUI

struct ContactInquiryHistoryView: View {
    @StateObject private var viewModel = ContactInquiryHistoryViewModel()

    let onBack: () -> Void
    let onNewInquiry: () -> Void
    let onOpenDetail: (ContactInquiryRecord) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    statusFilters
                    inquiryList
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            newInquiryAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text("1:1 문의 내역")
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

    private var statusFilters: some View {
        HStack(spacing: 8) {
            ForEach(ContactInquiryStatus.allCases) { status in
                filterButton(status)
            }
        }
    }

    private func filterButton(_ status: ContactInquiryStatus) -> some View {
        let isSelected = viewModel.selectedStatus == status
        return Button {
            viewModel.selectedStatus = status
        } label: {
            Text(status.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
                .overlay(Capsule().stroke(isSelected ? .clear : EUMColor.lineStrongSwiftUI, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var inquiryList: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.visibleInquiries) { inquiry in
                ContactInquiryCard(inquiry: inquiry, onTap: { onOpenDetail(inquiry) })
            }
        }
    }

    private var newInquiryAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: "1:1 문의하기", size: .large, action: onNewInquiry)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}

private struct ContactInquiryCard: View {
    let inquiry: ContactInquiryRecord
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 6) {
                    Text(inquiry.date)
                    Text("·")
                    Text(inquiry.category)
                    Spacer(minLength: 0)
                    statusBadge
                }
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)

                VStack(alignment: .leading, spacing: 8) {
                    Text(inquiry.title)
                        .font(EUMTypography.labelLarge)
                        .tracking(-0.16)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text(inquiry.summary)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 113, alignment: .leading)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(inquiry.date), \(inquiry.category), \(inquiry.title), \(inquiry.status.rawValue) 상세 보기")
    }

    private var statusBadge: some View {
        Text(inquiry.status.rawValue)
            .font(EUMTypography.labelExtraSmall)
            .foregroundStyle(inquiry.status == .answered ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(inquiry.status == .answered ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
            }
            .overlay {
                if inquiry.status == .pending {
                    RoundedRectangle(cornerRadius: 4).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
                }
            }
    }
}
