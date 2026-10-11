import Foundation

struct UserProfile: Identifiable {
    let id: String
    let uid: String
    let name: String
    let username: String
    let email: String
    let photoURL: String
    let bio: String
    let followerCount: Int
    let followingCount: Int
}
