import SwiftUI

struct SearchResultsList: View {
    let searchResults: [NowPlayingItem]
    
    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(searchResults, id: \.id) { movie in
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
