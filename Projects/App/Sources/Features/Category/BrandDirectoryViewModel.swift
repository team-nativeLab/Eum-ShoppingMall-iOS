import Combine
import Foundation

struct DirectoryBrand: Identifiable {
    let id: String
    let name: String
    let section: String

    var accessibilityLabel: String { "\(name), 제품 00개" }
}

enum BrandDirectoryLanguage: String, CaseIterable, Identifiable {
    case korean = "가나다"
    case latin = "ABC"

    var id: String { rawValue }
}

@MainActor
final class BrandDirectoryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var selectedLanguage = BrandDirectoryLanguage.korean
    @Published private(set) var selectedIndex = "전체"
    @Published private(set) var isAscending = true

    let languages = BrandDirectoryLanguage.allCases
    let brands = [
        DirectoryBrand(id: "brand-a", name: "브랜드 A", section: "ㄱ"),
        DirectoryBrand(id: "brand-b", name: "브랜드 B", section: "ㄱ"),
        DirectoryBrand(id: "brand-c", name: "브랜드 C", section: "ㄱ"),
        DirectoryBrand(id: "brand-d", name: "브랜드 D", section: "ㄱ"),
        DirectoryBrand(id: "brand-e", name: "브랜드 E", section: "ㄷ"),
        DirectoryBrand(id: "brand-f", name: "브랜드 F", section: "ㄷ"),
        DirectoryBrand(id: "brand-g", name: "브랜드 G", section: "ㄷ"),
        DirectoryBrand(id: "brand-h", name: "브랜드 H", section: "A–Z"),
        DirectoryBrand(id: "brand-i", name: "브랜드 I", section: "A–Z")
    ]

    var indexKeys: [String] {
        let koreanKeys = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
        let latinKeys = (65...90).compactMap(UnicodeScalar.init).map(String.init)
        return ["전체"] + (selectedLanguage == .korean ? koreanKeys + ["A–Z"] : latinKeys)
    }

    var filteredBrands: [DirectoryBrand] {
        brands
            .filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
            .filter {
                guard selectedIndex != "전체" else { return true }
                if selectedLanguage == .latin {
                    return $0.name.hasSuffix(selectedIndex)
                }
                return $0.section == selectedIndex
            }
            .sorted { isAscending ? $0.name < $1.name : $0.name > $1.name }
    }

    var visibleSections: [String] {
        if selectedLanguage == .latin {
            return filteredBrands.isEmpty ? [] : ["A–Z"]
        }
        let available = Set(filteredBrands.map(\.section))
        return ["ㄱ", "ㄷ", "A–Z"].filter { available.contains($0) }
    }

    func brands(in section: String) -> [DirectoryBrand] {
        selectedLanguage == .latin ? filteredBrands : filteredBrands.filter { $0.section == section }
    }

    func hasBrands(for index: String) -> Bool {
        guard index != "전체" else { return !brands.isEmpty }
        if selectedLanguage == .latin {
            return brands.contains { $0.name.hasSuffix(index) }
        }
        return brands.contains { $0.section == index }
    }

    func selectLanguage(_ language: BrandDirectoryLanguage) {
        selectedLanguage = language
        selectedIndex = "전체"
    }

    func selectIndex(_ index: String) {
        selectedIndex = index
    }

    func toggleSortOrder() {
        isAscending.toggle()
    }
}
