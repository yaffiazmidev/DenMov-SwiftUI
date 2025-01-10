import Foundation

struct PopularMovie: Codable, Identifiable {
    let id: Int?
    let title: String?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let release_date: String?
    let popularity: Double?
    let genre_ids: [Int]?
    let adult: Bool?
    let original_language: String?
    let vote_count: Int?
    let video: Bool?
}

struct PopularMovieResponse: Codable {
    let page: Int?
    let results: [PopularMovie]?
    let total_pages: Int?
    let total_results: Int?
} 
