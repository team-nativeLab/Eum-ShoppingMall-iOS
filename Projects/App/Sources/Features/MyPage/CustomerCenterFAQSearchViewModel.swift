import Foundation

struct CustomerCenterFAQSearchResult: Identifiable, Equatable {
    let id: String
    let question: String
}

struct CustomerCenterFAQSearchViewModel {
    let query: String
    let resultCountTitle = "검색 결과 00건"
    let results: [CustomerCenterFAQSearchResult]

    init(query: String = "배송") {
        self.query = query
        results = Self.sampleResults
    }

    func matchingResults(for query: String) -> [CustomerCenterFAQSearchResult] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else { return [] }

        return results.filter { $0.question.localizedCaseInsensitiveContains(normalizedQuery) }
    }

    private static let sampleResults = [
        CustomerCenterFAQSearchResult(
            id: "delivery-time",
            question: "주문 후 배송까지 얼마나 걸리나요?"
        ),
        CustomerCenterFAQSearchResult(
            id: "delivery-address",
            question: "배송지를 변경할 수 있나요?"
        )
    ]
}
