import Foundation

struct Trip: Identifiable, Codable, Hashable {
    let id: String
    let userID: String

    let title: String
    let city: City

    let startDate: Date?
    let endDate: Date?

    let note: String?
    let photoURLs: [String]

    let likeCount: Int
    let commentCount: Int

    let createdAt: Date
}
