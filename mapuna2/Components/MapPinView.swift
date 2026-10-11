import SwiftUI

struct MapPinView: View {

    enum State {
        case visited
        case wishlist
        case selected
    }

    let state: State

    var body: some View {
        ZStack {
            switch state {

            case .visited:
                Circle()
                    .fill(MapunaTheme.background)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Circle()
                            .stroke(MapunaTheme.lime, lineWidth: 3)
                    )

                Image(systemName: "mappin")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(MapunaTheme.lime)

            case .wishlist:
                Circle()
                    .fill(MapunaTheme.background.opacity(0.9))
                    .frame(width: 38, height: 38)
                    .overlay(
                        Circle()
                            .stroke(MapunaTheme.lime.opacity(0.55), lineWidth: 2)
                    )

                Image(systemName: "bookmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(MapunaTheme.lime.opacity(0.75))

            case .selected:
                Circle()
                    .fill(MapunaTheme.lime)
                    .frame(width: 42, height: 42)

                Image(systemName: "mappin")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.black)
            }
        }
        .shadow(
            color: .black.opacity(0.35),
            radius: 6,
            x: 0,
            y: 3
        )
    }
}

#Preview {
    HStack(spacing: 24) {
        MapPinView(state: .visited)
        MapPinView(state: .wishlist)
        MapPinView(state: .selected)
    }
    .padding()
    .background(Color.gray)
}
