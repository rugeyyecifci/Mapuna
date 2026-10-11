import SwiftUI

struct TripCardView: View {

    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.city.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(MapunaTheme.textPrimary)

                    Text(trip.city.country)
                        .font(.system(size: 15))
                        .foregroundStyle(MapunaTheme.textSecondary)
                }

                Spacer()

                Text(flagEmoji(for: trip.city.countryCode))
                    .font(.system(size: 28))
            }

            HStack(spacing: 18) {
                Label(
                    formattedDate(trip.startDate),
                    systemImage: "calendar"
                )

                Label(
                    "\(trip.photoURLs.count) photos",
                    systemImage: "photo"
                )
            }
            .font(.system(size: 14))
            .foregroundStyle(MapunaTheme.textSecondary)

            if let note = trip.note {
                Text(note)
                    .font(.system(size: 15))
                    .foregroundStyle(MapunaTheme.textPrimary)
                    .lineLimit(2)
            }

            HStack {
                Label(
                    "\(trip.likeCount)",
                    systemImage: "heart"
                )

                Label(
                    "\(trip.commentCount)",
                    systemImage: "bubble.left"
                )

                Spacer()

                Image(systemName: "chevron.right")
            }
            .font(.system(size: 15))
            .foregroundStyle(MapunaTheme.textSecondary)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(MapunaTheme.card)
        )
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "No date" }

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
