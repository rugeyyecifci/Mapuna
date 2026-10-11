import SwiftUI

struct CityDetailSheet: View {

    let city: City
    let trip: Trip?
    let onViewTrip: () -> Void

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(city.name)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(MapunaTheme.textPrimary)

                        Text(city.country)
                            .font(.system(size: 16))
                            .foregroundStyle(MapunaTheme.textSecondary)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(MapunaTheme.lime)
                            .frame(width: 52, height: 52)

                        Image(systemName: "mappin")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                    }
                }

                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(MapunaTheme.lime)

                    Text("Visited")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(MapunaTheme.textPrimary)
                }

                HStack(spacing: 28) {
                    stat(icon: "calendar", value: "3 days")
                    stat(icon: "photo", value: "14 photos")
                    stat(icon: "airplane", value: "1 trip")
                }

                Spacer()

                // TAM OLARAK BURAYA GELİYOR 👇
                if trip != nil {
                    Button {
                        onViewTrip()
                    } label: {
                        HStack {
                            Text("View trip")
                                .font(.system(size: 17, weight: .semibold))

                            Spacer()

                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 18)
                        .frame(height: 54)
                        .background(MapunaTheme.lime)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                }
            }
            .padding(24)
        }
    }

    private func stat(
        icon: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(MapunaTheme.lime)

            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(MapunaTheme.textPrimary)
        }
    }
}
