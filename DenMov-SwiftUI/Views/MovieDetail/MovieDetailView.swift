import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject private var movieStore: MovieStore
    @EnvironmentObject private var castStore: CastStore
    
    let movieId: Int
    
    var body: some View {
        ScrollView {
            if let movie = movieStore.movie {
                VStack(alignment: .leading, spacing: 0) {
                    // Backdrop Image
                    if let backdropPath = movie.backdrop_path,
                       let backdropURL = URL(string: URL.imageBaseURL.absoluteString + backdropPath) {
                        AsyncImage(url: backdropURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                        .frame(height: 250)
                        .clipped()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Movie Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title ?? "")
                                .font(.title)
                                .bold()
                            
                            HStack(spacing: 16) {
                                if let rating = movie.vote_average {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                        Text(String(format: "%.1f", rating))
                                    }
                                }
                                
                                if let runtime = movie.runtime {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock")
                                        Text("\(runtime) min")
                                    }
                                }
                                
                                if let releaseDate = movie.release_date {
                                    Text(releaseDate)
                                }
                            }
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        }
                        
                        // Overview
                        if let overview = movie.overview {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Overview")
                                    .font(.headline)
                                Text(overview)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Cast Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cast")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(castStore.cast, id: \.id) { cast in
                                        VStack(alignment: .leading, spacing: 4) {
                                            if let profilePath = cast.profile_path,
                                               let imageURL = URL(string: URL.imageBaseURL.absoluteString + profilePath) {
                                                AsyncImage(url: imageURL) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                                                    Rectangle()
                                                        .foregroundStyle(.gray.opacity(0.2))
                                                }
                                                .frame(width: 100, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(cast.name ?? "")
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                Text(cast.character ?? "")
                                                    .font(.caption2)
                                                    .foregroundStyle(.secondary)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            if movieStore.isLoading || castStore.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await movieStore.getMovie(id: movieId)
            await castStore.getMovieCredits(movieId: movieId)
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    let authRequest = NetworkRequestFactory.authRequest()
    MovieDetailView(
        movieId: 939243
    )
    .environmentObject(StoreFactory<CastStore>(network: authRequest).build())
    .environmentObject(StoreFactory<MovieStore>(network: authRequest).build())
}
