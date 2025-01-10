import Foundation

class MovieStore: BaseStore {
    private var network: NetworkRequest
    @Published var nowPlayingItems: [NowPlayingItem] = []
    @Published var movie: Movie?
    @Published var isLoading: Bool = false
    @Published var popularMovies: [PopularMovie] = []
    @Published var searchResults: [NowPlayingItem] = []
    
    // Pagination state
    private var currentNowPlayingPage: Int = 1
    private var currentPopularPage: Int = 1
    private var currentSearchPage: Int = 1
    private var hasMoreNowPlaying: Bool = true
    private var hasMorePopular: Bool = true
    private var hasMoreSearchResults: Bool = true
    
    required init(network: NetworkRequest = NetworkRequest()) {
        self.network = network
    }
    
    @MainActor
    func getNowPlaying() async {
        guard !isLoading && hasMoreNowPlaying else { return }
        isLoading = true
        
        let request = MovieEndpoint.nowPlaying(.init(page: currentNowPlayingPage)).url()
        
        do {
            let result: NowPlaying = try await network.request(from: request)
            if currentNowPlayingPage == 1 {
                nowPlayingItems = result.results ?? []
            } else {
                nowPlayingItems.append(contentsOf: result.results ?? [])
            }
            
            // Update pagination state
            currentNowPlayingPage += 1
            hasMoreNowPlaying = (result.total_pages ?? 0) > currentNowPlayingPage
            isLoading = false
        } catch {
            print("Error fetching now playing:", error.localizedDescription)
            isLoading = false
        }
    }
    
    @MainActor
    func getPopularMovies() async {
        guard !isLoading && hasMorePopular else { return }
        isLoading = true
        
        let request = MovieEndpoint.popular(.init(page: currentPopularPage)).url()
        
        do {
            let result: PopularMovieResponse = try await network.request(from: request)
            if currentPopularPage == 1 {
                popularMovies = result.results ?? []
            } else {
                popularMovies.append(contentsOf: result.results ?? [])
            }
            
            // Update pagination state
            currentPopularPage += 1
            hasMorePopular = (result.total_pages ?? 0) > currentPopularPage
            isLoading = false
        } catch {
            print("Error fetching popular movies:", error.localizedDescription)
            isLoading = false
        }
    }
    
    @MainActor
    func searchMovies(query: String) async {
        guard !isLoading else { return }
        
        // Reset search pagination when new search starts
        if currentSearchPage == 1 {
            searchResults = []
        }
        
        isLoading = true
        let request = MovieEndpoint.search(.init(
            query: query,
            page: currentSearchPage
        )).url()
        
        do {
            let result: NowPlaying = try await network.request(from: request)
            if currentSearchPage == 1 {
                searchResults = result.results ?? []
            } else {
                searchResults.append(contentsOf: result.results ?? [])
            }
            
            // Update pagination state
            currentSearchPage += 1
            hasMoreSearchResults = (result.total_pages ?? 0) > currentSearchPage
            isLoading = false
        } catch {
            print("Error searching movies:", error.localizedDescription)
            isLoading = false
        }
    }
    
    @MainActor
    func getMovie(id: Int) async {
        isLoading = true
        let request = MovieEndpoint.movie(id: id).url()
        
        do {
            movie = try await network.request(from: request)
            isLoading = false
        } catch {
            print("Error fetching movie details:", error.localizedDescription)
            isLoading = false
        }
    }
    
    // Reset pagination
    @MainActor
    func resetPagination() {
        currentNowPlayingPage = 1
        currentPopularPage = 1
        currentSearchPage = 1
        hasMoreNowPlaying = true
        hasMorePopular = true
        hasMoreSearchResults = true
        nowPlayingItems = []
        popularMovies = []
        searchResults = []
    }
    
    // Reset search pagination
    @MainActor
    func resetSearchPagination() {
        currentSearchPage = 1
        hasMoreSearchResults = true
        searchResults = []
    }
} 
