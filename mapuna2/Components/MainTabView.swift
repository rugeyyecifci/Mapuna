import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var appData: AppData

    enum Tab {
        case home
        case map
        case trips
        case profile
    }

    @State private var selectedTab: Tab = .home
    @State private var showAddTrip = false

    var body: some View {

        ZStack(alignment: .bottom) {

            currentView

            bottomBar
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showAddTrip) {
            AddTripView()
        }
        .onAppear {
            appData.loadTrips()
        }
    }

    @ViewBuilder
    private var currentView: some View {

        switch selectedTab {

        case .home:
            HomeView()

        case .map:
            MapView()

        case .trips:
            TripsView()

        case .profile:
            NavigationStack {
                ProfileView()
            }
        }
    }

    private var bottomBar: some View {

        HStack {

            tabButton(
                icon: "house.fill",
                title: "Home",
                tab: .home
            )

            tabButton(
                icon: "globe.europe.africa.fill",
                title: "Map",
                tab: .map
            )

            Button {
                showAddTrip = true
            } label: {

                ZStack {

                    Circle()
                        .fill(MapunaTheme.lime)
                        .frame(width: 68, height: 68)

                    Image(systemName: "plus")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            .offset(y: -14)

            tabButton(
                icon: "suitcase.fill",
                title: "Trips",
                tab: .trips
            )

            tabButton(
                icon: "person.fill",
                title: "Profile",
                tab: .profile
            )
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    Color(
                        red: 22 / 255,
                        green: 22 / 255,
                        blue: 22 / 255
                    )
                )
        )
    }

    private func tabButton(
        icon: String,
        title: String,
        tab: Tab
    ) -> some View {

        let selected = selectedTab == tab

        return Button {

            selectedTab = tab

        } label: {

            VStack(spacing: 5) {

                Image(systemName: icon)
                    .font(.system(size: 21))

                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(
                selected
                ? MapunaTheme.lime
                : Color.gray
            )
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppData())
}
