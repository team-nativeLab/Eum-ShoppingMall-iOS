import SwiftUI

@MainActor
final class DeliveryRequestViewModel: ObservableObject {
    static let options = ["문 앞에 놓아 주세요", "배송 전 연락 주세요", "경비실에 맡겨 주세요"]
    static let customTextLimit = 50

    @Published private(set) var selectedOption: String?
    @Published var customText: String

    init(initialSelection: String) {
        if Self.options.contains(initialSelection) {
            selectedOption = initialSelection
            customText = ""
        } else {
            selectedOption = nil
            customText = initialSelection == "선택해 주세요" ? "" : initialSelection
        }
    }

    var selection: String {
        let custom = customText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !custom.isEmpty { return String(custom.prefix(Self.customTextLimit)) }
        return selectedOption ?? "선택해 주세요"
    }

    func select(_ option: String) {
        selectedOption = selectedOption == option ? nil : option
        if selectedOption != nil { customText = "" }
    }

    func limitCustomText() {
        if customText.count > Self.customTextLimit {
            customText = String(customText.prefix(Self.customTextLimit))
        }
        if !customText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            selectedOption = nil
        }
    }
}

struct DeliveryRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DeliveryRequestViewModel

    let onComplete: (String) -> Void

    init(initialSelection: String, onComplete: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: DeliveryRequestViewModel(initialSelection: initialSelection))
        self.onComplete = onComplete
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("배송 시 전달할 내용을 선택해 주세요.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                    ForEach(DeliveryRequestViewModel.options, id: \.self) { option in
                        optionField(option)
                    }
                    directEntry
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomAction }
    }

    private var topBar: some View {
        ZStack {
            Text("배송 요청사항")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button { dismiss() } label: {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("이전 화면")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }

    private func optionField(_ option: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("선택 항목")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Button { viewModel.select(option) } label: {
                HStack(spacing: 8) {
                    Text(option)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Spacer()
                    if viewModel.selectedOption == option {
                        Image("ProfileEditCheck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.horizontal, 13)
                .frame(height: 50)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(option)
            .accessibilityAddTraits(viewModel.selectedOption == option ? .isSelected : [])
        }
    }

    private var directEntry: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("직접 입력")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            TextField("요청사항을 입력해 주세요", text: $viewModel.customText)
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, 13)
                .frame(height: 50)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                }
                .onChange(of: viewModel.customText) { _, _ in viewModel.limitCustomText() }
                .accessibilityLabel("배송 요청사항 직접 입력")
                .accessibilityIdentifier("delivery-request-custom-input")
        }
    }

    private var bottomAction: some View {
        EUMButton(title: "선택 완료", size: .large) {
            onComplete(viewModel.selection)
            dismiss()
        }
        .accessibilityIdentifier("delivery-request-complete")
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(EUMColor.backgroundSwiftUI)
    }
}
