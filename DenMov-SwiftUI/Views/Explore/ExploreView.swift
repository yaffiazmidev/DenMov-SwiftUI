import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var movieStore: MovieStore
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                SearchResultsList(searchResults: movieStore.searchResults)
            }
            .overlay {
                if movieStore.searchResults.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailView(
                    movieId: movieId
                )
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText, prompt: "Search movies")
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    if !newValue.isEmpty {
                        await movieStore.searchMovies(query: newValue)
                    } else {
                        movieStore.searchResults = []
                    }
                }
            }
        }
    }
}

#Preview {
    let authRequest = NetworkRequestFactory.authRequest()
    ExploreView()
        .environmentObject(StoreFactory<MovieStore>(network: authRequest).build())
}
