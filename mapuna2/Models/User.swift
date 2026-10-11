import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let username: String
    let name: String
    let bio: String?
    let profileImageURL: String?
    let countryCount: Int
    let cityCount: Int
    let continentCount: Int
    let followingCount: Int
    let followerCount: Int
}
