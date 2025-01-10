import Foundation

class StoreFactory<T: BaseStore & NetworkRequestProvider> {
    private let network: NetworkRequest
    
    init(network: NetworkRequest = NetworkRequest()) {
        self.network = network
    }
    
    func build() -> T {
        return T(network: network)
    }
}
