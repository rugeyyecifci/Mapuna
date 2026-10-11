import Foundation
import FirebaseAuth
import FirebaseFirestore

final class TripService {

    static let shared = TripService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Add Trip

    
    func deleteTrip(
        _ trip: Trip,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(TripServiceError.notLoggedIn))
            return
        }

        guard trip.userID == uid else {
            completion(.failure(TripServiceError.notOwner))
            return
        }

        db.collection("trips")
            .document(trip.id)
            .delete { error in

                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    
    
    func addTrip(
        _ trip: Trip,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(TripServiceError.notLoggedIn))
            return
        }

        var data: [String: Any] = [
            "id": trip.id,
            "userID": uid,
            "title": trip.title,

            "city": [
                "id": trip.city.id,
                "name": trip.city.name,
                "country": trip.city.country,
                "countryCode": trip.city.countryCode,
                "latitude": trip.city.latitude,
                "longitude": trip.city.longitude
            ],

            "note": trip.note ?? "",
            "photoURLs": trip.photoURLs,

            "likeCount": trip.likeCount,
            "commentCount": trip.commentCount,

            "createdAt": Timestamp(date: trip.createdAt)
        ]

        if let startDate = trip.startDate {
            data["startDate"] = Timestamp(date: startDate)
        }

        if let endDate = trip.endDate {
            data["endDate"] = Timestamp(date: endDate)
        }

        db.collection("trips")
            .document(trip.id)
            .setData(data) { error in

                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    // MARK: - Get Current User Trips

    func getCurrentUserTrips(
        completion: @escaping (Result<[Trip], Error>) -> Void
    ) {

        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(TripServiceError.notLoggedIn))
            return
        }

        db.collection("trips")
            .whereField("userID", isEqualTo: uid)
            .getDocuments { snapshot, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let trips: [Trip] = documents.compactMap { document in

                    let data = document.data()

                    guard
                        let id = data["id"] as? String,
                        let userID = data["userID"] as? String,
                        let title = data["title"] as? String,

                        let cityData = data["city"] as? [String: Any],
                        let cityID = cityData["id"] as? String,
                        let cityName = cityData["name"] as? String,
                        let country = cityData["country"] as? String,
                        let countryCode = cityData["countryCode"] as? String,
                        let latitude = cityData["latitude"] as? Double,
                        let longitude = cityData["longitude"] as? Double,

                        let likeCount = data["likeCount"] as? Int,
                        let commentCount = data["commentCount"] as? Int,

                        let createdAtTimestamp = data["createdAt"] as? Timestamp
                    else {
                        return nil
                    }

                    let city = City(
                        id: cityID,
                        name: cityName,
                        country: country,
                        countryCode: countryCode,
                        latitude: latitude,
                        longitude: longitude
                    )

                    let startDate =
                        (data["startDate"] as? Timestamp)?.dateValue()

                    let endDate =
                        (data["endDate"] as? Timestamp)?.dateValue()

                    let note = data["note"] as? String

                    let photoURLs =
                        data["photoURLs"] as? [String] ?? []

                    return Trip(
                        id: id,
                        userID: userID,
                        title: title,
                        city: city,
                        startDate: startDate,
                        endDate: endDate,
                        note: note?.isEmpty == true ? nil : note,
                        photoURLs: photoURLs,
                        likeCount: likeCount,
                        commentCount: commentCount,
                        createdAt: createdAtTimestamp.dateValue()
                    )
                }

                let sortedTrips = trips.sorted {
                    $0.createdAt > $1.createdAt
                }

                completion(.success(sortedTrips))
            }
        
        
        
    }
    
    

    
}



enum TripServiceError: LocalizedError {

    case notLoggedIn
    case notOwner

    var errorDescription: String? {

        switch self {

        case .notLoggedIn:
            return "User is not logged in."

        case .notOwner:
            return "You can only delete your own trips."
        }
    }
}
