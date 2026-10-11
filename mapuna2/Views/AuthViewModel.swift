import Foundation
import FirebaseAuth

final class AuthViewModel: ObservableObject {

    @Published var user: FirebaseAuth.User?
    @Published var isLoading = true
    @Published var hasUsername = false
    @Published var errorMessage: String?

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        listenToAuthState()
    }

    deinit {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }

    private func listenToAuthState() {

        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in

            guard let self else { return }

            DispatchQueue.main.async {
                self.user = user
            }

            guard let user else {
                DispatchQueue.main.async {
                    self.hasUsername = false
                    self.isLoading = false
                }
                return
            }

            self.loadUserProfile(for: user)
        }
    }

    private func loadUserProfile(
        for user: FirebaseAuth.User
    ) {

        UserService.shared.createUserIfNeeded(
            for: user
        ) { [weak self] result in

            guard let self else { return }

            switch result {

            case .success:
                self.refreshUsernameStatus()

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func refreshUsernameStatus() {

        guard let user else {
            hasUsername = false
            isLoading = false
            return
        }

        UserService.shared.getUsername(
            for: user.uid
        ) { [weak self] result in

            guard let self else { return }

            DispatchQueue.main.async {

                switch result {

                case .success(let username):
                    self.hasUsername = username != nil
                    self.errorMessage = nil
                    self.isLoading = false

                case .failure(let error):
                    self.hasUsername = false
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func signOut() {
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage = error.localizedDescription
            print(
                "Sign out error:",
                error.localizedDescription
            )
        }
    }
}
