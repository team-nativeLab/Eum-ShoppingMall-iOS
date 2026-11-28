import Foundation

struct ShoppingMallAPI {
    let storefront: StorefrontAPI
    let catalog: CatalogAPI
    let authentication: AuthenticationAPI
    let appAuthentication: AppAuthenticationAPI
    let member: MemberAPI
    let cart: CartAPI
    let orders: OrdersAPI
    let support: SupportAPI
    let quotes: QuotesAPI
    let brands: BrandsAPI
    let events: EventsAPI
    let legalDocuments: LegalDocumentsAPI
    let addresses: AddressesAPI
    let reviews: ReviewsAPI
    let productQuestions: ProductQuestionsAPI
    let discovery: DiscoveryAPI
    let accountSettings: AccountSettingsAPI

    init(configuration: APIConfiguration, session: URLSession = .shared) {
        let client = APIClient(configuration: configuration, session: session)
        storefront = StorefrontAPI(client: client)
        catalog = CatalogAPI(client: client)
        authentication = AuthenticationAPI(client: client)
        appAuthentication = AppAuthenticationAPI(client: client)
        member = MemberAPI(client: client)
        cart = CartAPI(client: client)
        orders = OrdersAPI(client: client)
        support = SupportAPI(client: client)
        quotes = QuotesAPI(client: client)
        brands = BrandsAPI(client: client)
        events = EventsAPI(client: client)
        legalDocuments = LegalDocumentsAPI(client: client)
        addresses = AddressesAPI(client: client)
        reviews = ReviewsAPI(client: client)
        productQuestions = ProductQuestionsAPI(client: client)
        discovery = DiscoveryAPI(client: client)
        accountSettings = AccountSettingsAPI(client: client)
    }

    init(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) throws {
        let configuration = try APIConfiguration(infoDictionary: infoDictionary)
        self.init(configuration: configuration)
    }
}
