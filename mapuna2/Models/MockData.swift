import Foundation

enum MockData {

    // MARK: - Cities

    static let paris = City(
        id: "paris-france",
        name: "Paris",
        country: "France",
        countryCode: "FR",
        latitude: 48.8566,
        longitude: 2.3522
    )

    static let rome = City(
        id: "rome-italy",
        name: "Rome",
        country: "Italy",
        countryCode: "IT",
        latitude: 41.9028,
        longitude: 12.4964
    )

    static let milan = City(
        id: "milan-italy",
        name: "Milan",
        country: "Italy",
        countryCode: "IT",
        latitude: 45.4642,
        longitude: 9.1900
    )

    static let athens = City(
        id: "athens-greece",
        name: "Athens",
        country: "Greece",
        countryCode: "GR",
        latitude: 37.9838,
        longitude: 23.7275
    )

    static let cities: [City] = [
        paris,
        rome,
        milan,
        athens
    ]

    // MARK: - Trips

    static let parisTrip = Trip(
        id: "paris-trip",
        userID: "current-user",
        title: "Paris Trip",
        city: paris,
        startDate: makeDate(2026, 8, 12),
        endDate: makeDate(2026, 8, 15),
        note: "Paris memories ✨",
        photoURLs: [
            "photo1",
            "photo2",
            "photo3"
        ],
        likeCount: 23,
        commentCount: 5,
        createdAt: Date()
    )

    static let romeTrip = Trip(
        id: "rome-trip",
        userID: "current-user",
        title: "Rome Trip",
        city: rome,
        startDate: makeDate(2026, 5, 20),
        endDate: makeDate(2026, 5, 25),
        note: "Rome was unforgettable.",
        photoURLs: [
            "photo1",
            "photo2"
        ],
        likeCount: 19,
        commentCount: 3,
        createdAt: Date()
    )

    static let trips: [Trip] = [
        parisTrip,
        romeTrip
    ]

    // MARK: - Helpers

    private static func makeDate(
        _ year: Int,
        _ month: Int,
        _ day: Int
    ) -> Date? {

        Calendar.current.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day
            )
        )
    }
}
