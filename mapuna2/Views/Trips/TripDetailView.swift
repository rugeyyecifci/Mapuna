import SwiftUI

struct TripDetailView: View {

    let trip: Trip

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    header

                    heroPhoto

                    infoRow

                    memorySection

                    placesSection

                    editButton
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)
                .padding(.bottom, 140)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(MapunaTheme.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(flagEmoji(for: trip.city.countryCode))
                    .font(.system(size: 28))

                Text(trip.city.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(MapunaTheme.textPrimary)
            }

            Text(trip.city.country)
                .font(.system(size: 16))
                .foregroundStyle(MapunaTheme.textSecondary)

            if let startDate = trip.startDate,
               let endDate = trip.endDate {

                Text("\(formattedDate(startDate)) – \(formattedDate(endDate))")
                    .font(.system(size: 15))
                    .foregroundStyle(MapunaTheme.textSecondary)
            }
        }
    }

    private var heroPhoto: some View {
        RoundedRectangle(cornerRadius: 26)
            .fill(MapunaTheme.card)
            .frame(height: 260)
            .overlay(
                VStack(spacing: 10) {
                    Image(systemName: "photo")
                        .font(.system(size: 38))
                        .foregroundStyle(MapunaTheme.textSecondary)

                    Text("Trip cover photo")
                        .foregroundStyle(MapunaTheme.textSecondary)
                }
            )
    }

    private var infoRow: some View {
        HStack(spacing: 12) {
            infoCard(
                icon: "calendar",
                value: "\(tripDuration) days"
            )

            infoCard(
                icon: "photo",
                value: "\(trip.photoURLs.count) photos"
            )

            infoCard(
                icon: "heart",
                value: "\(trip.likeCount) likes"
            )
        }
    }

    private func infoCard(
        icon: String,
        value: String
    ) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(MapunaTheme.lime)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(MapunaTheme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(MapunaTheme.card)
        )
    }

    private var memorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Memory")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(MapunaTheme.textPrimary)

            Text(trip.note ?? "No memory added yet.")
                .font(.system(size: 16))
                .foregroundStyle(MapunaTheme.textSecondary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(MapunaTheme.card)
                )
        }
    }

    private var placesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Place")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(MapunaTheme.textPrimary)

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(MapunaTheme.background)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(MapunaTheme.lime, lineWidth: 2)
                        )

                    Image(systemName: "mappin")
                        .foregroundStyle(MapunaTheme.lime)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.city.name)
                        .foregroundStyle(MapunaTheme.textPrimary)
                        .font(.system(size: 17, weight: .semibold))

                    Text(trip.city.country)
                        .foregroundStyle(MapunaTheme.textSecondary)
                        .font(.system(size: 14))
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(MapunaTheme.card)
            )
        }
    }

    private var editButton: some View {
        Button {
            print("Edit trip tapped")
        } label: {
            Text("Edit trip")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(MapunaTheme.lime)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )
        }
    }

    private var tripDuration: Int {
        guard let startDate = trip.startDate,
              let endDate = trip.endDate else {
            return 0
        }

        let days = Calendar.current.dateComponents(
            [.day],
            from: startDate,
            to: endDate
        ).day ?? 0

        return max(days + 1, 1)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func flagEmoji(for countryCode: String) -> String {
        countryCode
            .uppercased()
            .unicodeScalars
            .compactMap {
                UnicodeScalar(127397 + $0.value)
            }
            .map(String.init)
            .joined()
    }
}
