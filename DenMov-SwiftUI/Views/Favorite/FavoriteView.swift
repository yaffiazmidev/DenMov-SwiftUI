import SwiftUI

struct FavoriteView: View {
    @AppStorage("favoriteMovies") private var favoriteMoviesData: Data = Data()
    @State private var favoriteMovies: [NowPlayingItem] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favoriteMovies.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart",
                        description: Text("Your favorite movies will appear here")
                    )
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(favoriteMovies, id: \.id) { movie in
                            NavigationLink(value: movie.id) {
                                MovieRowItem(movie: movie)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailView(
                    movieId: movieId
                )
            }
            .navigationTitle("Favorites")
            .task {
                loadFavorites()
            }
        }
    }
    
    private func loadFavorites() {
        do {
            favoriteMovies = try JSONDecoder().decode([NowPlayingItem].self, from: favoriteMoviesData)
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
}

#Preview {
    FavoriteView()
} 
