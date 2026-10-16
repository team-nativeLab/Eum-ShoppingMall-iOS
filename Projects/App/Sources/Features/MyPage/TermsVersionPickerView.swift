import SwiftUI

enum TermsVersionOption: String, CaseIterable, Identifiable {
    case upcoming
    case current
    case previous
    case older

    var id: String { rawValue }

    var title: String {
        switch self {
        case .upcoming:
            "\(TermsDocument.effectiveDate) 시행 예정"
        case .current:
            "\(TermsDocument.effectiveDate) 시행 (현재)"
        case .previous, .older:
            "\(TermsDocument.effectiveDate) 시행"
        }
    }

    var showsPlannedBadge: Bool { self == .upcoming }

    var documentVersion: TermsView.Version? {
        switch self {
        case .upcoming: nil
        case .current: .current
        case .previous: .previous
        case .older: nil
        }
    }

    func isSelected(for version: TermsView.Version) -> Bool {
        switch (self, version) {
        case (.current, .current), (.current, .revisionScheduled), (.previous, .previous):
            true
        default:
            false
        }
    }
}

struct TermsVersionPickerView: View {
    let selectedVersion: TermsView.Version
    let onDismiss: () -> Void
    let onVersionSelected: (TermsVersionOption) -> Void

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            versionRows
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            Color.clear.frame(height: 34)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 350, alignment: .top)
        .background(EUMColor.backgroundSwiftUI)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.16), radius: 32, x: 0, y: -8)
        .accessibilityAddTraits(.isModal)
    }

    private var sheetHeader: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(EUMColor.lineStrongSwiftUI)
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .accessibilityHidden(true)
                .gesture(
                    DragGesture(minimumDistance: 18)
                        .onEnded { value in
                            if value.translation.height > 40 {
                                onDismiss()
                            }
                        }
                )

            HStack {
                Text("약관 버전")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Spacer(minLength: 0)

                Button(action: onDismiss) {
                    Image("ProductOptionClose")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
            }
            .padding(.leading, 20)
            .padding(.trailing, 8)
            .frame(height: 56)
        }
        .frame(height: 68, alignment: .top)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var versionRows: some View {
        VStack(spacing: 0) {
            ForEach(TermsVersionOption.allCases) { option in
                Button { onVersionSelected(option) } label: {
                    versionRow(option)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func versionRow(_ option: TermsVersionOption) -> some View {
        HStack(spacing: 12) {
            radio(for: option)

            Text(option.title)
                .font(.custom(
                    option.isSelected(for: selectedVersion) ? "NotoSansKR-Medium" : "NotoSansKR-Regular",
                    size: 16,
                    relativeTo: .body
                ))
                .tracking(option.isSelected(for: selectedVersion) ? -0.08 : -0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)

            if option.showsPlannedBadge {
                plannedBadge
            }
        }
        .padding(.horizontal, 0)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .overlay(alignment: .bottom) {
            if option != .older {
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(height: 1)
                    .accessibilityHidden(true)
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityValue(option.isSelected(for: selectedVersion) ? "선택됨" : "")
    }

    @ViewBuilder
    private func radio(for option: TermsVersionOption) -> some View {
        if option.isSelected(for: selectedVersion) {
            Image("ReturnRadioSelected")
                .resizable()
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)
        } else {
            Circle()
                .fill(EUMColor.backgroundSwiftUI)
                .overlay {
                    Circle()
                        .stroke(EUMColor.lineControlSwiftUI, lineWidth: 1.5)
                }
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)
        }
    }

    private var plannedBadge: some View {
        Text("예정")
            .font(EUMTypography.labelExtraSmall)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .padding(.horizontal, 6)
            .frame(height: 20)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
            }
    }
}
