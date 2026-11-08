import Foundation

struct CompanyIntroductionBusinessArea: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
}

struct CompanyIntroductionHistoryItem: Identifiable, Equatable {
    let id: String
    let year: String
    let description: String
    let isHighlighted: Bool
}

struct CompanyIntroductionCertification: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
}

struct CompanyIntroductionLocationRow: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
}

struct CompanyIntroductionViewModel {
    let heroTitle = "사람이 있는 곳에,\n더 안전한 내일을 연결합니다."
    let heroDescription = "이음산업건설은 현장과 사람을 잇는 안전용품 전문 기업입니다."
    let sectionNavigation = ["개요", "사업 분야", "연혁", "인증", "파트너", "오시는 길"]
    let overviewTitle = "현장의 안전을 연결하는 회사"
    let overviewDescription = "회사 소개 문구가 들어갑니다. 이음산업건설은 개인보호장비부터 현장 안전용품까지 필요한 제품을 연결합니다."
    let businessAreas = [
        CompanyIntroductionBusinessArea(
            id: "distribution",
            title: "안전용품 유통",
            description: "개인보호장비·작업복 등 현장 필수품",
            iconName: "CategoryHardHat"
        ),
        CompanyIntroductionBusinessArea(
            id: "delivery",
            title: "현장 납품",
            description: "건설·산업 현장 정기 납품",
            iconName: "CompanyBusinessTruck"
        ),
        CompanyIntroductionBusinessArea(
            id: "custom",
            title: "맞춤 제작",
            description: "로고 인쇄·사양 맞춤 제작",
            iconName: "CompanyBusinessClothing"
        ),
        CompanyIntroductionBusinessArea(
            id: "consulting",
            title: "안전 컨설팅",
            description: "현장 진단과 맞춤 안전 제안",
            iconName: "CompanyBusinessShield"
        )
    ]
    let historyItems = (0..<3).map { index in
        CompanyIntroductionHistoryItem(
            id: "history-\(index)",
            year: "0000",
            description: "00월 연혁 내용이 들어갑니다.",
            isHighlighted: index == 0
        )
    }
    let certifications = (0..<2).map { index in
        CompanyIntroductionCertification(
            id: "certification-\(index)",
            title: "인증서",
            description: "인증 내용이 들어갑니다"
        )
    }
    let partners = ["파트너 로고", "파트너 로고", "파트너 로고"]
    let locationRows = [
        CompanyIntroductionLocationRow(id: "address", title: "주소", value: "서울특별시 00구 00로 00, 00빌딩"),
        CompanyIntroductionLocationRow(id: "phone", title: "고객센터", value: "0000-0000 (평일 00:00 – 00:00)"),
        CompanyIntroductionLocationRow(id: "email", title: "이메일", value: "info@example.com")
    ]
}
