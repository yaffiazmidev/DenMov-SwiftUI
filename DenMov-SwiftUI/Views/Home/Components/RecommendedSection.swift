import SwiftUI

struct RecommendedSection: View {
    let movies: [PopularMovie]
    let onLoadMore: () async -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommended")
                .font(.title2)
                .bold()
            
            LazyVStack(spacing: 16) {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink(value: movie.id) {
                        MovieRowItem(movie: movie)
                            .task {
                                if movie.id == movies.last?.id {
                                    await onLoadMore()
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
} 
