import SwiftUI

struct BrandDirectoryView: View {
    var onIndexSelected: (String) -> Void
    var onBrandSelected: (String) -> Void

    @StateObject private var viewModel = BrandDirectoryViewModel()

    var body: some View {
        VStack(spacing: 0) {
            spotlight
            searchAndSort
            indexSelector
            brandGroups
        }
    }

    private var spotlight: some View {
        Button { onBrandSelected("brand-a") } label: {
            HStack(spacing: 16) {
                logoPlate(size: 64)
                VStack(alignment: .leading, spacing: 4) {
                    Text("이달의 브랜드")
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.inverseSecondarySwiftUI)
                    Text("브랜드 A")
                        .font(EUMTypography.heading3)
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                    Text("브랜드 한 줄 소개가 들어갑니다.")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.inverseSecondarySwiftUI)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image("SectionChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(EUMColor.inverseSwiftUI)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.text1SwiftUI)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("이달의 브랜드, 브랜드 A")
    }

    private var searchAndSort: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .accessibilityHidden(true)
                TextField("어떤 브랜드를 찾고 계신가요?", text: $viewModel.searchText)
                    .font(EUMTypography.bodySmall)
                    .textInputAutocapitalization(.never)
                    .accessibilityLabel("브랜드 검색")
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(EUMColor.surfaceSwiftUI, in: Capsule())

            Button {
                viewModel.toggleSortOrder()
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 40, height: 40)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                    .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(viewModel.isAscending ? "가나다순 정렬" : "역순 정렬")
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.vertical, 12)
    }

    private var indexSelector: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                ForEach(viewModel.languages) { language in
                    indexButton(language.rawValue, isLanguage: true)
                }
                ForEach(viewModel.indexKeys, id: \.self) { key in
                    indexButton(key, isLanguage: false)
                }
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
        }
        .scrollIndicators(.hidden)
        .frame(height: 48)
        .overlay(alignment: .bottom) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }

    private func indexButton(_ title: String, isLanguage: Bool) -> some View {
        let isSelected = isLanguage ? viewModel.selectedLanguage.rawValue == title : viewModel.selectedIndex == title
        return Button {
            if isLanguage {
                if let language = BrandDirectoryLanguage(rawValue: title) {
                    viewModel.selectLanguage(language)
                }
                onIndexSelected("")
            } else {
                viewModel.selectIndex(title)
                let section = title == "전체" ? "" : (viewModel.selectedLanguage == .latin ? "A–Z" : title)
                onIndexSelected(section)
            }
        } label: {
            Text(title)
                .font(title.count > 1 ? EUMTypography.labelExtraSmall : EUMTypography.labelLarge)
                .foregroundStyle(indexTextColor(title, isSelected: isSelected, isLanguage: isLanguage))
                .frame(minWidth: title == "전체" ? 40 : 36, minHeight: 36)
                .padding(.horizontal, title.count > 1 ? 4 : 0)
                .background {
                    if isSelected && !isLanguage {
                        Capsule().fill(EUMColor.text1SwiftUI)
                    } else if isSelected {
                        RoundedRectangle(cornerRadius: EUMRadius.medium).fill(EUMColor.surfaceSwiftUI)
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .disabled(!isLanguage && !viewModel.hasBrands(for: title))
    }

    private func indexTextColor(_ title: String, isSelected: Bool, isLanguage: Bool) -> Color {
        if isSelected {
            return isLanguage ? EUMColor.text1SwiftUI : EUMColor.inverseSwiftUI
        }
        return isLanguage || viewModel.hasBrands(for: title) ? EUMColor.text2SwiftUI : EUMColor.textDisabledSwiftUI
    }

    private var brandGroups: some View {
        VStack(spacing: 16) {
            if viewModel.filteredBrands.isEmpty {
                Text("검색 결과가 없습니다.")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .frame(maxWidth: .infinity, minHeight: 180)
            }
            ForEach(viewModel.visibleSections, id: \.self) { section in
                brandSection(section)
                    .id(section)
            }
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 8)
    }

    private func brandSection(_ section: String) -> some View {
        let sectionBrands = viewModel.brands(in: section)
        return VStack(spacing: 0) {
            HStack(spacing: 6) {
                Text(section)
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("00개")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Spacer()
            }
            .frame(height: 40, alignment: .bottomLeading)
            Rectangle().fill(EUMColor.lineStrongSwiftUI).frame(height: 1)
            ForEach(sectionBrands) { brand in
                brandRow(brand)
            }
        }
    }

    private func brandRow(_ brand: DirectoryBrand) -> some View {
        Button { onBrandSelected(brand.id) } label: {
            HStack(spacing: 12) {
                logoPlate(size: 56)
                VStack(alignment: .leading, spacing: 2) {
                    Text(brand.name)
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Text("제품 00개")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                Spacer(minLength: 0)
                Image("SectionChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(height: 72)
            .contentShape(Rectangle())
            .overlay(alignment: .bottom) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(brand.accessibilityLabel)
    }

    private func logoPlate(size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: EUMRadius.button)
            .fill(EUMColor.surfaceSwiftUI)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: size == 64 ? 20 : 18))
                    .foregroundStyle(EUMColor.lineStrongSwiftUI)
                    .frame(width: size - 12, height: size - 12)
                    .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
            }
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .accessibilityHidden(true)
    }
}
