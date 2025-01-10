import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(TabItem.home.title, systemImage: TabItem.home.icon)
                }
                .tag(TabItem.home)
            
            ExploreView()
                .tabItem {
                    Label(TabItem.explore.title, systemImage: TabItem.explore.icon)
                }
                .tag(TabItem.explore)
            
            FavoriteView()
                .tabItem {
                    Label(TabItem.favorite.title, systemImage: TabItem.favorite.icon)
                }
                .tag(TabItem.favorite)
        }
    }
}

#Preview {
    let authRequest = NetworkRequestFactory.authRequest()
    MainTabView()
        .environmentObject(StoreFactory<MovieStore>(network: authRequest).build())
}
