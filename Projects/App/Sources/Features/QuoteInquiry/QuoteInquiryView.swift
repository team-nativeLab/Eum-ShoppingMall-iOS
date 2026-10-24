import SwiftUI
import UniformTypeIdentifiers

struct QuoteInquiryView: View {
    @StateObject private var viewModel: QuoteInquiryViewModel
    @State private var presentedMessage: String?
    @State private var isFileImporterPresented = false
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    @State private var isSubmitted = false
    @State private var isShowingPrivacyConsent = false
    let onBack: () -> Void
    let onViewInquiries: () -> Void
    let onContinueShopping: () -> Void

    init(
        product: HomeProduct? = nil,
        onBack: @escaping () -> Void,
        onContinueShopping: @escaping () -> Void,
        onViewInquiries: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onContinueShopping = onContinueShopping
        self.onViewInquiries = onViewInquiries
        _viewModel = StateObject(wrappedValue: QuoteInquiryViewModel(product: product))
    }

    var body: some View {
        Group {
            if isSubmitted {
                QuoteInquiryCompletionView(
                    details: viewModel.completionDetails,
                    onClose: onBack,
                    onContinueShopping: onContinueShopping,
                    onViewInquiries: onViewInquiries
                )
            } else {
                VStack(spacing: 0) {
                    topBar
                    ScrollView {
                        VStack(spacing: 24) {
                            QuoteInquiryIntroSection()
                            QuoteInquiryProductsSection(viewModel: viewModel)
                            QuoteInquiryFieldsView(
                                viewModel: viewModel,
                                isDatePickerPresented: $isDatePickerPresented,
                                isFileImporterPresented: $isFileImporterPresented,
                                onMessage: { presentedMessage = $0 },
                                onShowPrivacyConsent: { isShowingPrivacyConsent = true }
                            )
                        }
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                        .padding(.vertical, 24)
                    }
                    .scrollIndicators(.hidden)
                    QuoteInquiryBottomAction(isEnabled: viewModel.canSubmit) {
                        isSubmitted = true
                    }
                }
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .overlay {
            if isShowingPrivacyConsent {
                PrivacyConsentView(
                    onClose: { isShowingPrivacyConsent = false },
                    onAgree: {
                        if !viewModel.agreedToPrivacy {
                            viewModel.togglePrivacyAgreement()
                        }
                        isShowingPrivacyConsent = false
                    }
                )
            }
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true,
            onCompletion: handleFileImport
        )
        .sheet(isPresented: $isDatePickerPresented) {
            datePickerSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("견적 문의")
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
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("뒤로 가기")
                .accessibilityIdentifier("quote-inquiry-back")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var datePickerSheet: some View {
        NavigationStack {
            DatePicker("희망 납기", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("취소") { isDatePickerPresented = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("완료", action: setDeliveryDate)
                    }
                }
        }
    }

    private func setDeliveryDate() {
        viewModel.deliveryDate = selectedDate.formatted(
            .dateTime.year().month().day().locale(Locale(identifier: "ko_KR"))
        )
        isDatePickerPresented = false
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case let .success(urls):
            viewModel.addAttachments(urls.map(\.lastPathComponent))
        case let .failure(error):
            presentedMessage = "파일을 불러오지 못했어요. \(error.localizedDescription)"
        }
    }
}

struct QuoteInquiryViewPreview: PreviewProvider {
    static var previews: some View {
        QuoteInquiryView(onBack: {}, onContinueShopping: {}, onViewInquiries: {})
    }
}
