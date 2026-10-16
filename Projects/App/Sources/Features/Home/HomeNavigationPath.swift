import Foundation

enum HomeDestination {
    case screen(HomeModalRoute)
    case product(HomeProduct)
    case checkoutAddress
    case checkoutPayment
    case checkoutComplete(CheckoutPaymentMethod)
}

struct HomeNavigationEntry: Identifiable {
    let id = UUID()
    let destination: HomeDestination
}

struct HomeNavigationPath {
    private(set) var entries: [HomeNavigationEntry] = []

    var isEmpty: Bool { entries.isEmpty }
    var topID: UUID? { entries.last?.id }

    mutating func push(_ destination: HomeDestination) {
        entries.append(HomeNavigationEntry(destination: destination))
    }

    mutating func back() {
        _ = entries.popLast()
    }

    mutating func reset() {
        entries.removeAll()
    }
}
