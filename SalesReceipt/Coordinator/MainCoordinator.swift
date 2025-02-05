final class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    private let factory: CoordinatorFactory
    
    init(factory: CoordinatorFactory = DefaultCoordinatorFactory()) {
        self.factory = factory
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .sales:
            factory.createSalesView()
                .environmentObject(self)
        case .dailySales:
            factory.createDailySalesView()
                .environmentObject(self)
        case .receiptDetail(let receipt):
            factory.createReceiptDetailView(receipt: receipt)
                .environmentObject(self)
        }
    }
    
    func start() -> some View {
        NavigationStack(path: $path) {
            view(for: .sales)
                .navigationDestination(for: Route.self) { route in
                    view(for: route)
                }
        }
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func showDailySales() {
        navigate(to: .dailySales)
    }
    
    func showReceiptDetail(receipt: Receipt) {
        navigate(to: .receiptDetail(receipt))
    }
    
    func dismiss() {
        if !path.isEmpty {
            navigateBack()
        }
    }
} 