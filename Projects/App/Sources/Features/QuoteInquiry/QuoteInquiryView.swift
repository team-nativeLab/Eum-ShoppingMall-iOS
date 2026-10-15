import SwiftUI
import UniformTypeIdentifiers

struct QuoteInquiryView: View {
    @StateObject private var viewModel: QuoteInquiryViewModel
    @State private var presentedMessage: String?
    @State private var isFileImporterPresented = false
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    let onBack: () -> Void

    init(product: HomeProduct? = nil, onBack: @escaping () -> Void) {
        self.onBack = onBack
        _viewModel = StateObject(wrappedValue: QuoteInquiryViewModel(product: product))
    }

    var body: some View {
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
                        onMessage: { presentedMessage = $0 }
                    )
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
            QuoteInquiryBottomAction(isEnabled: viewModel.canSubmit) {
                presentedMessage = "견적 문의 접수는 서버 연동 후 이용할 수 있어요."
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
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
                }
                .buttonStyle(.plain)
                .accessibilityLabel("뒤로 가기")
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
        QuoteInquiryView(onBack: {})
    }
}
