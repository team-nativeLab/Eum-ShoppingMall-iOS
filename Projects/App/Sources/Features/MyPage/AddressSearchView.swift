import SwiftUI

struct AddressSearchResult: Identifiable, Equatable {
    let postalCode: String
    let address: String

    var id: String { postalCode + address }
}

@MainActor
final class AddressSearchViewModel: ObservableObject {
    static let mockResults = [
        AddressSearchResult(postalCode: "06164", address: "서울특별시 강남구 테헤란로 427"),
        AddressSearchResult(postalCode: "06173", address: "서울특별시 강남구 영동대로 513"),
        AddressSearchResult(postalCode: "04524", address: "서울특별시 중구 세종대로 110")
    ]

    @Published var query = ""
    @Published private(set) var results: [AddressSearchResult]
    @Published var selectedResult: AddressSearchResult?
    @Published private(set) var hasSearched = false

    init() {
        results = [Self.mockResults[0]]
        selectedResult = Self.mockResults[0]
    }

    var noResultsMessage: String? {
        hasSearched && results.isEmpty ? "검색 결과가 없어요. 주소를 다시 확인해 주세요." : nil
    }

    func search() {
        let normalizedQuery = query
            .lowercased()
            .filter { !$0.isWhitespace }
        hasSearched = true
        guard !normalizedQuery.isEmpty else {
            results = Self.mockResults
            selectedResult = results.first
            return
        }
        results = Self.mockResults.filter { result in
            let normalizedAddress = result.address.lowercased().filter { !$0.isWhitespace }
            return normalizedAddress.contains(normalizedQuery) || result.postalCode.contains(normalizedQuery)
        }
        selectedResult = results.first
    }

    func select(_ result: AddressSearchResult) {
        selectedResult = result
    }
}

struct AddressSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddressSearchViewModel()

    let onSelect: (AddressSearchResult) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("도로명 또는 지번 주소를 입력해 주세요.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                    searchField
                    VStack(alignment: .leading, spacing: 8) {
                        Text("검색 결과")
                            .font(EUMTypography.labelMedium)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        if let noResultsMessage = viewModel.noResultsMessage {
                            Text(noResultsMessage)
                                .font(EUMTypography.bodySmall)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                                .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
                                .accessibilityIdentifier("address-search-empty")
                        } else {
                            ForEach(viewModel.results) { result in
                                resultRow(result)
                            }
                        }
                    }
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
            Text("주소 검색")
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
                .accessibilityLabel("배송지 편집으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }

    private var searchField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주소 검색")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            TextField("예: 테헤란로 427", text: $viewModel.query)
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, 13)
                .frame(height: 50)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                }
                .submitLabel(.search)
                .onSubmit(viewModel.search)
                .accessibilityIdentifier("address-search-query")
        }
    }

    private func resultRow(_ result: AddressSearchResult) -> some View {
        let isSelected = viewModel.selectedResult == result
        return Button { viewModel.select(result) } label: {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.address)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("우편번호 \(result.postalCode)")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                Spacer(minLength: 0)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, 13)
            .frame(minHeight: 50)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.button)
                    .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("address-search-result-\(result.postalCode)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var bottomAction: some View {
        EUMButton(title: "주소 선택", size: .large) {
            guard let selectedResult = viewModel.selectedResult else { return }
            onSelect(selectedResult)
            dismiss()
        }
        .disabled(viewModel.selectedResult == nil)
        .accessibilityIdentifier("address-search-select")
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(EUMColor.backgroundSwiftUI)
    }
}
