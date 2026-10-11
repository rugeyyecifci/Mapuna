import Foundation

struct City: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let country: String
    let countryCode: String
    let latitude: Double
    let longitude: Double
}
