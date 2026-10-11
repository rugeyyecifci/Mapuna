import SwiftUI

struct RootView: View {

    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {

            if authViewModel.isLoading {

                ZStack {
                    MapunaTheme.background
                        .ignoresSafeArea()

                    ProgressView()
                        .tint(MapunaTheme.lime)
                }

            } else if authViewModel.user == nil {

                LoginView()
                    .environmentObject(authViewModel)

            } else if !authViewModel.hasUsername {

                UsernameSetupView()
                    .environmentObject(authViewModel)

            } else {

                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    RootView()
}
