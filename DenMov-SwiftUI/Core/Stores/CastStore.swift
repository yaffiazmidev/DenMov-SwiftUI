import Foundation

class CastStore: BaseStore {
    private var network: NetworkRequest
    @Published var isLoading: Bool = false
    @Published var cast: [Cast] = []
    
    required init(network: NetworkRequest = NetworkRequest()) {
        self.network = network
    }
    
    @MainActor
    func getMovieCredits(movieId: Int) async {
        guard !isLoading else { return }
        isLoading = true
        let request = MovieEndpoint.credits(movieId: movieId).url()
        
        do {
            let result: MovieCredits = try await network.request(from: request)
            cast = result.cast?.sorted(by: { ($0.order ?? 0) < ($1.order ?? 0) }) ?? []
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }
}
