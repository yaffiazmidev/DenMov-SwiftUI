import SwiftUI

// First, let's create a protocol for our movie types
protocol MovieDisplayable: Identifiable {
    var id: Int? { get }
    var title: String? { get }
    var poster_path: String? { get }
    var release_date: String? { get }
}

// Make our models conform to MovieDisplayable
extension PopularMovie: MovieDisplayable {}
extension NowPlayingItem: MovieDisplayable {
    var title: String? { original_title }
}

struct HomeView: View {
    @EnvironmentObject private var movieStore: MovieStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Popular Movies Banner Section
                    PopularMoviesBanner(
                        movies: movieStore.popularMovies,
                        onLoadMore: movieStore.getPopularMovies
                    )
                    
                    // Now Playing Section
                    MovieSection(
                        title: "Now Playing",
                        movies: movieStore.nowPlayingItems
                    ) { movie in
                        NavigationLink(value: movie.id) {
                            MoviePosterCard(movie: movie)
                                .frame(width: 140, height: 210)
                        }
                        .buttonStyle(.plain)
                    } onLoadMore: {
                        await movieStore.getNowPlaying()
                    }
                    
                    // Recommended Section
                    RecommendedSection(
                        movies: movieStore.popularMovies,
                        onLoadMore: movieStore.getPopularMovies
                    )
                }
                .padding()
            }
            .navigationTitle("Movies")
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailView(
                    movieId: movieId
                )
            }
            .refreshable {
                movieStore.resetPagination()
                await movieStore.getPopularMovies()
                await movieStore.getNowPlaying()
            }
            .task {
                await movieStore.getPopularMovies()
                await movieStore.getNowPlaying()
            }
        }
    }
}

// Update MovieSection to use generic type
struct MovieSection<T: MovieDisplayable, Content: View>: View {
    let title: String
    let movies: [T]
    let content: (T) -> Content
    let onLoadMore: () async -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        content(movie)
                            .task {
                                if movie.id == movies.last?.id {
                                    await onLoadMore()
                                }
                            }
                    }
                }
            }
        }
    }
}

// Update MoviePosterCard to use MovieDisplayable
struct MoviePosterCard: View {
    let movie: any MovieDisplayable
    
    var body: some View {
        VStack(alignment: .leading) {
            if let posterPath = movie.poster_path,
               let imageURL = URL(string: URL.imageBaseURL.absoluteString + posterPath) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.2))
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text(movie.title ?? "")
                .font(.caption)
                .lineLimit(2)
        }
    }
}

// Update MovieRowItem to use MovieDisplayable
struct MovieRowItem: View {
    let movie: any MovieDisplayable
    
    var body: some View {
        HStack(spacing: 16) {
            if let posterPath = movie.poster_path,
               let imageURL = URL(string: URL.imageBaseURL.absoluteString + posterPath) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.2))
                }
                .frame(width: 80, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title ?? "")
                    .font(.headline)
                
                if let releaseDate = movie.release_date {
                    Text(releaseDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
    }
}

// New Banner Card View
struct BannerCard: View {
    let movie: PopularMovie
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if let backdropPath = movie.backdrop_path,
               let imageURL = URL(string: URL.imageBaseURL.absoluteString + backdropPath) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            
            // Gradient Overlay
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title ?? "")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                
                if let releaseDate = movie.release_date {
                    Text(releaseDate)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                if let voteAverage = movie.vote_average {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", voteAverage))
                            .foregroundStyle(.white)
                    }
                    .font(.subheadline)
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let authRequest = NetworkRequestFactory.authRequest()
    HomeView()
        .environmentObject(StoreFactory<CastStore>(network: authRequest).build())
        .environmentObject(StoreFactory<MovieStore>(network: authRequest).build())
}
