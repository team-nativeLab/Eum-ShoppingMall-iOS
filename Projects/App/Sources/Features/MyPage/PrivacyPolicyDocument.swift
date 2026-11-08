import Foundation

struct PrivacyPolicyDetailRow: Identifiable, Equatable {
    let label: String
    let value: String

    var id: String { label }
}

struct PrivacyPolicySection: Identifiable, Equatable {
    let title: String
    let includesSampleItems: Bool
    let detailRows: [PrivacyPolicyDetailRow]
    let usesSubtleCard: Bool

    var id: String { title }
}

enum PrivacyPolicyDocument {
    static let effectiveDate = "0000.00.00"
    static let articleBody = "조항 내용이 들어갑니다."
    static let itemBody = "항 내용이 들어갑니다."

    static let sections = [
        PrivacyPolicySection(title: "1. 개인정보의 처리 목적", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "2. 처리하는 개인정보의 항목", includesSampleItems: true, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "3. 개인정보의 처리 및 보유 기간", includesSampleItems: true, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "4. 개인정보의 제3자 제공", includesSampleItems: false, detailRows: [
            PrivacyPolicyDetailRow(label: "제공받는 자", value: "000"),
            PrivacyPolicyDetailRow(label: "제공 목적", value: "000"),
            PrivacyPolicyDetailRow(label: "제공 항목", value: "000"),
            PrivacyPolicyDetailRow(label: "보유·이용 기간", value: "000")
        ], usesSubtleCard: false),
        PrivacyPolicySection(title: "5. 개인정보 처리업무의 위탁", includesSampleItems: false, detailRows: [
            PrivacyPolicyDetailRow(label: "수탁자", value: "000"),
            PrivacyPolicyDetailRow(label: "위탁 업무", value: "000"),
            PrivacyPolicyDetailRow(label: "위탁 항목", value: "000"),
            PrivacyPolicyDetailRow(label: "보유·이용 기간", value: "000")
        ], usesSubtleCard: false),
        PrivacyPolicySection(title: "6. 개인정보의 파기 절차 및 방법", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "7. 정보주체와 법정대리인의 권리·의무 및 행사방법", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "8. 개인정보의 안전성 확보조치", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "9. 개인정보 자동 수집 장치의 설치·운영 및 거부", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "10. 개인정보 보호책임자", includesSampleItems: false, detailRows: [
            PrivacyPolicyDetailRow(label: "성명", value: "000"),
            PrivacyPolicyDetailRow(label: "직책", value: "000"),
            PrivacyPolicyDetailRow(label: "연락처", value: "0000-0000"),
            PrivacyPolicyDetailRow(label: "이메일", value: "000@000")
        ], usesSubtleCard: true),
        PrivacyPolicySection(title: "11. 권익침해 구제방법", includesSampleItems: false, detailRows: [], usesSubtleCard: false),
        PrivacyPolicySection(title: "12. 개인정보 처리방침의 변경", includesSampleItems: false, detailRows: [], usesSubtleCard: false)
    ]
}
