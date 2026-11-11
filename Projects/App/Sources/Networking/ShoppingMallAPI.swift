import Foundation

struct ShoppingMallAPI {
    let storefront: StorefrontAPI
    let catalog: CatalogAPI
    let authentication: AuthenticationAPI
    let member: MemberAPI
    let cart: CartAPI
    let orders: OrdersAPI
    let support: SupportAPI
    let quotes: QuotesAPI

    init(configuration: APIConfiguration, session: URLSession = .shared) {
        let client = APIClient(configuration: configuration, session: session)
        storefront = StorefrontAPI(client: client)
        catalog = CatalogAPI(client: client)
        authentication = AuthenticationAPI(client: client)
        member = MemberAPI(client: client)
        cart = CartAPI(client: client)
        orders = OrdersAPI(client: client)
        support = SupportAPI(client: client)
        quotes = QuotesAPI(client: client)
    }

    init(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) throws {
        let configuration = try APIConfiguration(infoDictionary: infoDictionary)
        self.init(configuration: configuration)
    }
}
