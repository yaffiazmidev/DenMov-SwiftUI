import Foundation

struct Movie: Codable {
    let id: Int?
    let title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let release_date: String?
    let runtime: Int?
} 
