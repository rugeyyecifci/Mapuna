import Foundation
import Combine

final class AppData: ObservableObject {

    @Published var trips: [Trip] = []
    @Published var cities: [City] = []

    @Published var isLoadingTrips = false
    @Published var tripErrorMessage: String?

    init() {
        loadTrips()
    }

    // MARK: - Load Trips

    
    func removeTrip(_ trip: Trip) {

        trips.removeAll {
            $0.id == trip.id
        }

        let remainingCityIDs = Set(
            trips.map { $0.city.id }
        )

        cities.removeAll {
            !remainingCityIDs.contains($0.id)
        }
    }
    
    
    
    func loadTrips() {

        isLoadingTrips = true
        tripErrorMessage = nil

        TripService.shared.getCurrentUserTrips { [weak self] result in

            guard let self else { return }

            DispatchQueue.main.async {

                self.isLoadingTrips = false

                switch result {

                case .success(let trips):

                    self.trips = trips

                    self.cities = Array(
                        Dictionary(
                            grouping: trips.map { $0.city },
                            by: { $0.id }
                        )
                        .compactMap { $0.value.first }
                    )

                    self.tripErrorMessage = nil

                case .failure(let error):

                    self.trips = []
                    self.cities = []

                    self.tripErrorMessage =
                        error.localizedDescription
                }
            }
        }
    }

    // MARK: - Add Trip

    func addTrip(_ trip: Trip) {

        trips.append(trip)

        if !cities.contains(
            where: { $0.id == trip.city.id }
        ) {
            cities.append(trip.city)
        }
    }
}
