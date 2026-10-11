import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

final class AuthService {

    static let shared = AuthService()

    private init() {}

    func signInWithGoogle(
        completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void
    ) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(AuthServiceError.missingClientID))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootViewController = rootViewController() else {
            completion(.failure(AuthServiceError.missingViewController))
            return
        }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthServiceError.missingGoogleToken))
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let firebaseUser = authResult?.user else {
                    completion(.failure(AuthServiceError.missingFirebaseUser))
                    return
                }

                completion(.success(firebaseUser))
            }
        }
    }

    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }

    private func rootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return nil
        }

        return topViewController(from: root)
    }

    private func topViewController(
        from controller: UIViewController
    ) -> UIViewController {

        if let presented = controller.presentedViewController {
            return topViewController(from: presented)
        }

        if let navigation = controller as? UINavigationController,
           let visible = navigation.visibleViewController {
            return topViewController(from: visible)
        }

        if let tab = controller as? UITabBarController,
           let selected = tab.selectedViewController {
            return topViewController(from: selected)
        }

        return controller
    }
}

enum AuthServiceError: LocalizedError {
    case missingClientID
    case missingViewController
    case missingGoogleToken
    case missingFirebaseUser

    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Google Client ID bulunamadı."
        case .missingViewController:
            return "Google giriş ekranı açılamadı."
        case .missingGoogleToken:
            return "Google giriş bilgileri alınamadı."
        case .missingFirebaseUser:
            return "Firebase kullanıcı bilgisi alınamadı."
        }
    }
}
