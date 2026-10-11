import SwiftUI

struct TripsView: View {

    @EnvironmentObject var appData: AppData

    @State private var tripToDelete: Trip?
    @State private var showDeleteAlert = false
    @State private var errorMessage: String?

    var body: some View {

        NavigationStack {

            ZStack {

                MapunaTheme.background
                    .ignoresSafeArea()

                ScrollView {

                    VStack(
                        alignment: .leading,
                        spacing: 22
                    ) {

                        header

                        stats

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 13))
                                .foregroundStyle(.red)
                        }

                        if appData.trips.isEmpty {

                            emptyState

                        } else {

                            Text("2026")
                                .font(
                                    .system(
                                        size: 28,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(
                                    MapunaTheme.textPrimary
                                )

                            ForEach(appData.trips) { trip in

                                NavigationLink {

                                    TripDetailView(
                                        trip: trip
                                    )

                                } label: {

                                    TripCardView(
                                        trip: trip
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {

                                    Button(
                                        role: .destructive
                                    ) {

                                        tripToDelete = trip
                                        showDeleteAlert = true

                                    } label: {

                                        Label(
                                            "Delete Trip",
                                            systemImage: "trash"
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
            .alert(
                "Delete Trip?",
                isPresented: $showDeleteAlert,
                presenting: tripToDelete
            ) { trip in

                Button(
                    "Cancel",
                    role: .cancel
                ) {}

                Button(
                    "Delete",
                    role: .destructive
                ) {
                    deleteTrip(trip)
                }

            } message: { trip in

                Text(
                    "\(trip.city.name) trip will be permanently deleted."
                )
            }
        }
    }

    private var header: some View {

        VStack(
            alignment: .leading,
            spacing: 6
        ) {

            Text("mapuna.")
                .font(
                    .system(
                        size: 34,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.lime
                )

            Text("My Trips")
                .font(
                    .system(
                        size: 30,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )

            Text(
                "Your travel history, year by year."
            )
            .font(.system(size: 15))
            .foregroundStyle(
                MapunaTheme.textSecondary
            )
        }
    }

    private var stats: some View {

        HStack(spacing: 10) {

            statCard(
                value: "\(appData.trips.count)",
                title: "Trips"
            )

            statCard(
                value: "\(countryCount)",
                title: "Countries"
            )

            statCard(
                value: "\(cityCount)",
                title: "Cities"
            )
        }
    }

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

    private var emptyState: some View {

        VStack(spacing: 12) {

            Image(
                systemName: "airplane"
            )
            .font(.system(size: 36))
            .foregroundStyle(
                MapunaTheme.lime
            )

            Text("No trips yet")
                .font(
                    .system(
                        size: 20,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )

            Text(
                "Add your first trip to start building your map."
            )
            .font(.system(size: 14))
            .foregroundStyle(
                MapunaTheme.textSecondary
            )
            .multilineTextAlignment(
                .center
            )
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 50)
    }

    private func statCard(
        value: String,
        title: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 6
        ) {

            Text(value)
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.lime
                )

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(
                    MapunaTheme.textSecondary
                )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(14)
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(MapunaTheme.card)
        )
    }

    private func deleteTrip(
        _ trip: Trip
    ) {

        errorMessage = nil

        TripService.shared.deleteTrip(
            trip
        ) { result in

            DispatchQueue.main.async {

                switch result {

                case .success:

                    appData.removeTrip(
                        trip
                    )

                case .failure(let error):

                    errorMessage =
                        error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    TripsView()
        .environmentObject(
            AppData()
        )
}
