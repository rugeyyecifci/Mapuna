import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserService {

    static let shared = UserService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Create User If Needed

    func createUserIfNeeded(
        for firebaseUser: FirebaseAuth.User,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        let userRef = db
            .collection("users")
            .document(firebaseUser.uid)

        userRef.getDocument { document, error in

            if let error {
                completion(.failure(error))
                return
            }

            if let document, document.exists {
                completion(.success(()))
                return
            }

            let data: [String: Any] = [
                "uid": firebaseUser.uid,
                "name": firebaseUser.displayName ?? "",
                "email": firebaseUser.email ?? "",
                "photoURL": firebaseUser.photoURL?.absoluteString ?? "",
                "bio": "",
                "username": "",
                "followerCount": 0,
                "followingCount": 0,
                "createdAt": FieldValue.serverTimestamp()
            ]

            userRef.setData(data) { error in

                if let error {
                    completion(.failure(error))
                    return
                }

                completion(.success(()))
            }
        }
    }

    // MARK: - Check Username

    func isUsernameAvailable(
        _ username: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {

        let cleanUsername = username
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let usernameRef = db
            .collection("usernames")
            .document(cleanUsername)

        usernameRef.getDocument { document, error in

            if let error {
                completion(.failure(error))
                return
            }

            completion(.success(document?.exists == false))
        }
    }

    // MARK: - Save Username

    func saveUsername(
        _ username: String,
        for user: FirebaseAuth.User,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        let cleanUsername = username
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let userRef = db
            .collection("users")
            .document(user.uid)

        let usernameRef = db
            .collection("usernames")
            .document(cleanUsername)

        db.runTransaction({ transaction, errorPointer -> Any? in

            do {
                let usernameDocument = try transaction.getDocument(usernameRef)

                if usernameDocument.exists {
                    errorPointer?.pointee = NSError(
                        domain: "MapunaUsername",
                        code: 1,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "This username is already taken."
                        ]
                    )

                    return nil
                }

                transaction.setData(
                    [
                        "uid": user.uid
                    ],
                    forDocument: usernameRef
                )

                transaction.updateData(
                    [
                        "username": cleanUsername
                    ],
                    forDocument: userRef
                )

            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }

            return nil

        }) { _, error in

            if let error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }
    }

    // MARK: - Get Username

    func getUsername(
        for uid: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {

        db.collection("users")
            .document(uid)
            .getDocument { document, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                let username =
                    document?.data()?["username"] as? String

                if let username,
                   !username.isEmpty {

                    completion(.success(username))

                } else {

                    completion(.success(nil))
                }
            }
    }
    
    
    func getUserProfile(
        for uid: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {

        db.collection("users")
            .document(uid)
            .getDocument { document, error in

                if let error {
                    completion(.failure(error))
                    return
                }

                guard let document,
                      let data = document.data() else {

                    completion(
                        .failure(
                            NSError(
                                domain: "MapunaUserProfile",
                                code: 1,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "User profile not found."
                                ]
                            )
                        )
                    )

                    return
                }

                let profile = UserProfile(
                    id: document.documentID,
                    uid: data["uid"] as? String ?? uid,
                    name: data["name"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    photoURL: data["photoURL"] as? String ?? "",
                    bio: data["bio"] as? String ?? "",
                    followerCount: data["followerCount"] as? Int ?? 0,
                    followingCount: data["followingCount"] as? Int ?? 0
                )

                completion(.success(profile))
            }
    }
    
    func updateProfile(
        uid: String,
        name: String,
        bio: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        let userRef = db
            .collection("users")
            .document(uid)

        userRef.updateData([
            "name": name,
            "bio": bio
        ]) { error in

            if let error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }
    }
    
    
}
