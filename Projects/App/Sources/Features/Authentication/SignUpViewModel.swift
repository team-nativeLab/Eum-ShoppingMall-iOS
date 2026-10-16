import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var email = "" {
        didSet {
            isEmailChecked = false
            if taxInvoiceEmailMatchesAccount {
                taxInvoiceEmail = email
            }
        }
    }
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var name = ""
    @Published var phoneNumber = "" {
        didSet { isPhoneVerified = false }
    }
    @Published var verificationCode = "" {
        didSet { isPhoneVerified = false }
    }
    @Published private(set) var isEmailChecked = false
    @Published private(set) var isPhoneVerified = false
    @Published private(set) var agreedToTerms = false
    @Published private(set) var agreedToPrivacy = false
    @Published private(set) var agreedToMarketing = false
    @Published private(set) var isBusinessMember = false
    @Published var businessRegistrationNumber = "" {
        didSet { isBusinessRegistrationVerified = false }
    }
    @Published var companyName = ""
    @Published var representativeName = ""
    @Published var businessType = ""
    @Published var taxInvoiceEmail = ""
    @Published private(set) var taxInvoiceEmailMatchesAccount = true
    @Published private(set) var isBusinessRegistrationVerified = false
    @Published var registrationCertificateName: String?

    var passwordIsValid: Bool {
        password.range(of: "^(?=.*[A-Za-z])(?=.*\\d).{8,}$", options: .regularExpression) != nil
    }

    var canSubmit: Bool {
        email.contains("@") && email.contains(".") && isEmailChecked && passwordIsValid
            && password == passwordConfirmation && !name.isEmpty
            && phoneNumber.filter(\.isNumber).count >= 10
            && isPhoneVerified && agreedToTerms && agreedToPrivacy && businessFieldsAreValid
    }

    private var businessFieldsAreValid: Bool {
        guard isBusinessMember else { return true }
        return isBusinessRegistrationVerified && !companyName.isEmpty
            && !representativeName.isEmpty && registrationCertificateName != nil
    }

    func selectMemberType(isBusiness: Bool) {
        isBusinessMember = isBusiness
        if isBusiness {
            businessRegistrationNumber = "000-00-00000"
            isBusinessRegistrationVerified = true
        }
    }

    func verifyBusinessRegistration() -> Bool {
        guard businessRegistrationNumber.filter(\.isNumber).count == 10 else { return false }
        isBusinessRegistrationVerified = true
        return true
    }

    func setTaxInvoiceEmailMatchesAccount(_ matches: Bool) {
        taxInvoiceEmailMatchesAccount = matches
        if matches {
            taxInvoiceEmail = email
        }
    }

    func markEmailChecked() -> Bool {
        guard email.contains("@"), email.contains(".") else { return false }
        isEmailChecked = true
        return true
    }

    func verifyPhoneCode() -> Bool {
        guard phoneNumber.filter(\.isNumber).count >= 10, verificationCode == "123456" else {
            return false
        }
        isPhoneVerified = true
        return true
    }

    func toggleTerms() {
        agreedToTerms.toggle()
    }

    func agreeToTerms() {
        agreedToTerms = true
    }

    func togglePrivacy() {
        agreedToPrivacy.toggle()
    }

    func toggleMarketing() {
        agreedToMarketing.toggle()
    }

    func toggleAllAgreements() {
        let shouldAgree = !(agreedToTerms && agreedToPrivacy && agreedToMarketing)
        agreedToTerms = shouldAgree
        agreedToPrivacy = shouldAgree
        agreedToMarketing = shouldAgree
    }
}
