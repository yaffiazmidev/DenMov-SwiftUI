import SwiftUI

struct PopularMoviesBanner: View {
    let movies: [PopularMovie]
    let onLoadMore: () async -> Void
    
    var body: some View {
        TabView {
            ForEach(movies.prefix(5), id: \.id) { movie in
                NavigationLink(value: movie.id) {
                    BannerCard(movie: movie)
                        .task {
                            if movie.id == movies[4].id {
                                await onLoadMore()
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 220)
        .tabViewStyle(.page)
    }
} 
