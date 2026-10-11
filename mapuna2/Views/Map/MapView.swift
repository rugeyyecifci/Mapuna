import SwiftUI
import MapKit

struct MapView: View {

    @EnvironmentObject var appData: AppData

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 48.0,
                longitude: 12.0
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 35,
                longitudeDelta: 35
            )
        )
    )

    @State private var selectedCity: City?
    @State private var selectedTrip: Trip?
    @State private var showTripDetail = false

    var body: some View {

        ZStack(alignment: .top) {

            Map(position: $position) {

                ForEach(appData.cities) { city in

                    Annotation(
                        city.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: city.latitude,
                            longitude: city.longitude
                        )
                    ) {

                        Button {

                            selectedCity = city

                        } label: {

                            MapPinView(
                                state:
                                    selectedCity?.id == city.id
                                    ? .selected
                                    : .visited
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea()

            header
        }
        .sheet(item: $selectedCity) { city in

            let trip = tripForCity(city)

            CityDetailSheet(
                city: city,
                trip: trip
            ) {

                guard let trip else {
                    return
                }

                selectedTrip = trip
                selectedCity = nil

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.4
                ) {
                    showTripDetail = true
                }
            }
            .presentationDetents([
                .height(330)
            ])
            .presentationDragIndicator(
                .visible
            )
            .presentationCornerRadius(28)
        }
        .fullScreenCover(
            isPresented: $showTripDetail
        ) {

            if let trip = selectedTrip {

                NavigationStack {

                    TripDetailView(
                        trip: trip
                    )
                    .toolbar {

                        ToolbarItem(
                            placement: .topBarLeading
                        ) {

                            Button("Close") {
                                showTripDetail = false
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text("Your World")
                    .font(
                        .system(
                            size: 30,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)

                Text(
                    "\(countryCount) countries · \(cityCount) cities"
                )
                .font(.system(size: 14))
                .foregroundStyle(
                    .white.opacity(0.7)
                )
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
    }

    // MARK: - Real Stats

    private var countryCount: Int {

        Set(
            appData.trips.map {
                $0.city.country
            }
        ).count
    }

    private var cityCount: Int {

        Set(
            appData.trips.map {
                $0.city.id
            }
        ).count
    }

    // MARK: - Find Trip

    private func tripForCity(
        _ city: City
    ) -> Trip? {

        appData.trips.first {
            $0.city.id == city.id
        }
    }
}

#Preview {
    MapView()
        .environmentObject(
            AppData()
        )
}
