import SwiftUI
import FirebaseAuth

struct LoginView: View {

    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                VStack(spacing: 12) {
                    Text("mapuna.")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundStyle(MapunaTheme.lime)

                    Text("your world, mapped.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(MapunaTheme.textPrimary)

                    Text("Sign in to keep your trips,\nmemories and places together.")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(MapunaTheme.textSecondary)
                }

                Spacer()

                VStack(spacing: 14) {

                    Button {
                        signInWithGoogle()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 22))

                            Text("Continue with Google")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .disabled(isLoading)

                    Button {
                        print("Apple later")
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 22))

                            Text("Continue with Apple")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(MapunaTheme.card)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .disabled(true)

                    if isLoading {
                        ProgressView()
                            .tint(MapunaTheme.lime)
                            .padding(.top, 8)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }

                    Text("By continuing, you agree to Mapuna's Terms and Privacy Policy.")
                        .font(.system(size: 11))
                        .foregroundStyle(MapunaTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                }

                Spacer()
                    .frame(height: 18)
            }
            .padding(.horizontal, 24)
        }
    }

    private func signInWithGoogle() {
        isLoading = true
        errorMessage = nil

        AuthService.shared.signInWithGoogle { result in

            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let user):
                    print("Google login success:", user.email ?? "No email")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
