import SwiftUI
import FirebaseAuth

struct UsernameSetupView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var username = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Spacer()

                VStack(spacing: 12) {

                    Text("mapuna.")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(MapunaTheme.lime)

                    Text("Create your profile")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(MapunaTheme.textPrimary)

                    Text("Choose a unique username for Mapuna.")
                        .font(.system(size: 15))
                        .foregroundStyle(MapunaTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Username")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(MapunaTheme.textSecondary)

                    HStack(spacing: 8) {

                        Text("@")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(MapunaTheme.lime)

                        TextField("username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundStyle(MapunaTheme.textPrimary)
                            .font(.system(size: 17, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(MapunaTheme.card)
                    )
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 13))
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                Button {
                    continueTapped()
                } label: {

                    HStack {

                        if isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Continue")
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(MapunaTheme.lime)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                }
                .disabled(
                    isLoading ||
                    cleanUsername.count < 3
                )
                .opacity(
                    cleanUsername.count < 3 ? 0.5 : 1
                )

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }

    private var cleanUsername: String {
        username
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func continueTapped() {

        errorMessage = nil

        guard cleanUsername.count >= 3 else {
            errorMessage =
                "Username must be at least 3 characters."
            return
        }

        guard cleanUsername.count <= 20 else {
            errorMessage =
                "Username must be 20 characters or less."
            return
        }

        let allowedCharacters =
            CharacterSet(
                charactersIn:
                    "abcdefghijklmnopqrstuvwxyz0123456789._"
            )

        if cleanUsername.unicodeScalars.contains(
            where: {
                !allowedCharacters.contains($0)
            }
        ) {
            errorMessage =
                "Use only letters, numbers, . or _"
            return
        }

        guard let firebaseUser = authViewModel.user else {
            errorMessage = "User session not found."
            return
        }

        isLoading = true

        UserService.shared.isUsernameAvailable(
            cleanUsername
        ) { result in

            DispatchQueue.main.async {

                switch result {

                case .success(let isAvailable):

                    if !isAvailable {
                        isLoading = false
                        errorMessage =
                            "This username is already taken."
                        return
                    }

                    saveUsername(
                        for: firebaseUser
                    )

                case .failure(let error):
                    isLoading = false
                    errorMessage =
                        error.localizedDescription
                }
            }
        }
    }

    private func saveUsername(
        for user: FirebaseAuth.User
    ) {

        UserService.shared.saveUsername(
            cleanUsername,
            for: user
        ) { result in

            DispatchQueue.main.async {

                isLoading = false

                switch result {

                case .success:
                    errorMessage = nil

                    authViewModel.refreshUsernameStatus()

                    print(
                        "Username saved:",
                        cleanUsername
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
    UsernameSetupView()
        .environmentObject(AuthViewModel())
}
