enum TabItem {
    case home
    case explore
    case favorite
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .favorite: return "Favorite"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .explore: return "safari"
        case .favorite: return "heart"
        }
    }
} 