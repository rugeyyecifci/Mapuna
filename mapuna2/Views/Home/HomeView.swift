import SwiftUI

struct HomeView: View {

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    header

                    statsSection

                    mainTripCard

                    activitySection
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
        }
    }
}

private extension HomeView {

    var header: some View {
        HStack {

            Text("mapuna.")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(MapunaTheme.lime)

            Spacer()

            HStack(spacing: 12) {

                Button {
                    print("Notifications tapped")
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(MapunaTheme.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(MapunaTheme.card)
                        )
                }

                Button {
                    print("Friends tapped")
                } label: {
                    Image(systemName: "person.2")
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
    }

    var statsSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Your world lately")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(MapunaTheme.textPrimary)

            HStack(spacing: 12) {

                statCard(
                    value: "12",
                    title: "Countries",
                    icon: "globe"
                )

                statCard(
                    value: "34",
                    title: "Cities",
                    icon: "building.2"
                )

                statCard(
                    value: "3",
                    title: "Continents",
                    icon: "map"
                )
            }
        }
    }

    func statCard(
        value: String,
        title: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(MapunaTheme.lime)

            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(MapunaTheme.lime)

            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(MapunaTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(MapunaTheme.card)
        )
    }

    var mainTripCard: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack {

                Circle()
                    .fill(MapunaTheme.secondaryCard)
                    .frame(width: 46, height: 46)
                    .overlay(
                        Text("E")
                            .font(.headline)
                            .foregroundStyle(MapunaTheme.textPrimary)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Ece visited Paris 🇫🇷")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(MapunaTheme.textPrimary)

                    Text("12–15 August")
                        .font(.system(size: 14))
                        .foregroundStyle(MapunaTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundStyle(MapunaTheme.textSecondary)
            }
            .padding(16)

            Rectangle()
                .fill(MapunaTheme.secondaryCard)
                .frame(height: 240)
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "photo")
                            .font(.system(size: 36))
                            .foregroundStyle(MapunaTheme.textSecondary)

                        Text("Paris photo")
                            .foregroundStyle(MapunaTheme.textSecondary)
                    }
                )

            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(MapunaTheme.lime)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Paris, France")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(MapunaTheme.textPrimary)

                        Text("3 days · 14 photos")
                            .font(.system(size: 14))
                            .foregroundStyle(MapunaTheme.textSecondary)
                    }

                    Spacer()
                }

                HStack(spacing: 22) {

                    Label("23", systemImage: "heart")
                    Label("5", systemImage: "bubble.left")

                    Spacer()

                    Image(systemName: "bookmark")
                }
                .font(.system(size: 16))
                .foregroundStyle(MapunaTheme.textPrimary)
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(MapunaTheme.card)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 26)
        )
    }

    var activitySection: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Friends activity")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(MapunaTheme.textPrimary)

            activityCard(
                icon: "bookmark.fill",
                title: "Mert added Tokyo",
                subtitle: "to his wishlist"
            )

            activityCard(
                icon: "party.popper.fill",
                title: "Selin visited",
                subtitle: "her 20th country 🎉"
            )
        }
    }

    func activityCard(
        icon: String,
        title: String,
        subtitle: String
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(MapunaTheme.lime)
                .frame(width: 46, height: 46)
                .background(
                    Circle()
                        .fill(MapunaTheme.secondaryCard)
                )

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(MapunaTheme.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(MapunaTheme.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(MapunaTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(MapunaTheme.card)
        )
    }
}


private let sampleTrip = Trip(
    id: "trip-paris-1",
    userID: "user-ece",
    title: "Paris Trip",
    city: City(
        id: "paris-france",
        name: "Paris",
        country: "France",
        countryCode: "FR",
        latitude: 48.8566,
        longitude: 2.3522
    ),
    startDate: Date(),
    endDate: Date(),
    note: "Paris memories",
    photoURLs: [],
    likeCount: 23,
    commentCount: 5,
    createdAt: Date()
)



#Preview {
    HomeView()
}
