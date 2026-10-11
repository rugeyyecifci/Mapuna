import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var appData: AppData
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var profile: UserProfile?
    @State private var isLoadingProfile = true
    @State private var profileError: String?

    private var visitedCities: [City] {
        Array(
            Set(
                appData.trips.map { $0.city }
            )
        )
    }

    private var cityCount: Int {
        visitedCities.count
    }

    private var countryCount: Int {
        Set(
            visitedCities.map { $0.country }
        ).count
    }

    private var continentCount: Int {
        countryCount > 0 ? 1 : 0
    }

    private var tripCount: Int {
        appData.trips.count
    }

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            if isLoadingProfile {

                ProgressView()
                    .tint(MapunaTheme.lime)

            } else {

                ScrollView {
                    VStack(
                        alignment: .leading,
                        spacing: 24
                    ) {

                        header
                        profileInfo
                        travelStats
                        myWorldSection
                        yearSummary
                        recentMemories
                        signOutButton
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            loadProfile()
        }
    }

    // MARK: - Load Profile

    private func loadProfile() {

        guard let uid = authViewModel.user?.uid else {
            isLoadingProfile = false
            profileError = "User not found."
            return
        }

        UserService.shared.getUserProfile(
            for: uid
        ) { result in

            DispatchQueue.main.async {

                isLoadingProfile = false

                switch result {

                case .success(let profile):
                    self.profile = profile
                    profileError = nil

                case .failure(let error):
                    profileError = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {

            Text("mapuna.")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(MapunaTheme.lime)

            Spacer()

            Button {
                print("Settings tapped")
            } label: {

                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(MapunaTheme.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(MapunaTheme.card)
                    )
            }
        }
    }

    // MARK: - Profile Info

    private var profileInfo: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            HStack(spacing: 16) {

                profileImage

                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {

                    Text(
                        profile?.name.isEmpty == false
                        ? profile!.name
                        : "Mapuna User"
                    )
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(MapunaTheme.textPrimary)

                    if let username = profile?.username,
                       !username.isEmpty {

                        Text("@\(username)")
                            .font(.system(size: 16))
                            .foregroundStyle(MapunaTheme.lime)
                    }

                    if let bio = profile?.bio,
                       !bio.isEmpty {

                        Text(bio)
                            .font(.system(size: 15))
                            .foregroundStyle(MapunaTheme.textSecondary)
                    }

                    if let error = profileError {

                        Text(error)
                            .font(.system(size: 12))
                            .foregroundStyle(.red)
                    }
                }

                Spacer()
            }

            // MARK: Edit Profile

            if let profile {

                NavigationLink {

                    EditProfileView(
                        profile: profile
                    ) {
                        loadProfile()
                    }

                } label: {

                    Text("Edit Profile")
                        .font(
                            .system(
                                size: 15,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            MapunaTheme.textPrimary
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(height: 46)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                            .fill(
                                MapunaTheme.card
                            )
                        )
                }
            }

            HStack(spacing: 22) {

                Text(
                    "\(profile?.followingCount ?? 0) Following"
                )

                Text(
                    "\(profile?.followerCount ?? 0) Followers"
                )
            }
            .font(
                .system(
                    size: 15,
                    weight: .medium
                )
            )
            .foregroundStyle(
                MapunaTheme.textPrimary
            )
        }
    }

    // MARK: - Profile Image

    @ViewBuilder
    private var profileImage: some View {

        if let photoURLString = profile?.photoURL,
           let url = URL(string: photoURLString),
           !photoURLString.isEmpty {

            AsyncImage(url: url) { phase in

                switch phase {

                case .empty:
                    profilePlaceholder

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    profilePlaceholder

                @unknown default:
                    profilePlaceholder
                }
            }
            .frame(width: 86, height: 86)
            .clipShape(Circle())

        } else {

            profilePlaceholder
        }
    }

    private var profilePlaceholder: some View {

        Circle()
            .fill(MapunaTheme.card)
            .frame(width: 86, height: 86)
            .overlay(

                Text(
                    String(
                        (profile?.name ?? "M")
                            .prefix(1)
                    )
                    .uppercased()
                )
                .font(
                    .system(
                        size: 34,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.lime
                )
            )
    }

    // MARK: - Travel Stats

    private var travelStats: some View {

        HStack(spacing: 10) {

            statCard(
                value: "\(countryCount)",
                title: "Countries"
            )

            statCard(
                value: "\(cityCount)",
                title: "Cities"
            )

            statCard(
                value: "\(continentCount)",
                title: "Continents"
            )
        }
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
                        size: 26,
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
            RoundedRectangle(cornerRadius: 20)
                .fill(MapunaTheme.card)
        )
    }

    // MARK: - My World

    private var myWorldSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("My World")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        MapunaTheme.textPrimary
                    )

                Spacer()

                Text("View map")
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        MapunaTheme.lime
                    )
            }

            RoundedRectangle(cornerRadius: 24)
                .fill(MapunaTheme.card)
                .frame(height: 180)
                .overlay(

                    VStack(spacing: 10) {

                        Image(
                            systemName:
                                "globe.europe.africa.fill"
                        )
                        .font(.system(size: 54))
                        .foregroundStyle(
                            MapunaTheme.lime
                        )

                        Text(
                            "\(countryCount) countries · \(cityCount) cities"
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            MapunaTheme.textPrimary
                        )
                    }
                )
        }
    }

    // MARK: - Year Summary

    private var yearSummary: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("2026")
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )

            HStack(spacing: 12) {

                summaryItem(
                    icon: "airplane",
                    value: "\(tripCount) trips"
                )

                summaryItem(
                    icon: "building.2",
                    value: "\(cityCount) cities"
                )

                summaryItem(
                    icon: "globe",
                    value: "\(countryCount) countries"
                )
            }
        }
    }

    private func summaryItem(
        icon: String,
        value: String
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .foregroundStyle(
                    MapunaTheme.lime
                )

            Text(value)
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(MapunaTheme.card)
        )
    }

    // MARK: - Recent Memories

    private var recentMemories: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Recent Memories")
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )

            HStack(spacing: 10) {

                memoryCard(title: "Paris")
                memoryCard(title: "Rome")
                memoryCard(title: "Milan")
            }
        }
    }

    private func memoryCard(
        title: String
    ) -> some View {

        RoundedRectangle(cornerRadius: 20)
            .fill(MapunaTheme.card)
            .frame(height: 120)
            .overlay(

                VStack(spacing: 8) {

                    Image(systemName: "photo")
                        .foregroundStyle(
                            MapunaTheme.lime
                        )

                    Text(title)
                        .font(
                            .system(
                                size: 14,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            MapunaTheme.textPrimary
                        )
                }
            )
    }

    // MARK: - Sign Out

    private var signOutButton: some View {

        Button {
            authViewModel.signOut()
        } label: {

            HStack(spacing: 12) {

                Image(
                    systemName:
                        "rectangle.portrait.and.arrow.right"
                )

                Text("Sign out")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )

                Spacer()
            }
            .foregroundStyle(.red)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(MapunaTheme.card)
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppData())
        .environmentObject(AuthViewModel())
}
