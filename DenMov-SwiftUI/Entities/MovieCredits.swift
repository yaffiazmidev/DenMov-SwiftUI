import Foundation

struct MovieCredits: Codable {
    let id: Int?
    let cast: [Cast]?
}

struct Cast: Codable {
    let id: Int?
    let name: String?
    let character: String?
    let profile_path: String?
    let order: Int?
} 
