import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss

    let profile: UserProfile
    let onSaved: () -> Void

    @State private var name: String
    @State private var bio: String

    @State private var isSaving = false
    @State private var errorMessage: String?

    init(
        profile: UserProfile,
        onSaved: @escaping () -> Void
    ) {
        self.profile = profile
        self.onSaved = onSaved

        _name = State(initialValue: profile.name)
        _bio = State(initialValue: profile.bio)
    }

    var body: some View {
        ZStack {
            MapunaTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    header

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text("Name")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(MapunaTheme.textSecondary)

                        TextField(
                            "Your name",
                            text: $name
                        )
                        .foregroundStyle(MapunaTheme.textPrimary)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(MapunaTheme.card)
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text("Username")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(MapunaTheme.textSecondary)

                        HStack {
                            Text("@\(profile.username)")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(MapunaTheme.textSecondary)

                            Spacer()

                            Image(systemName: "lock.fill")
                                .foregroundStyle(MapunaTheme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(MapunaTheme.card)
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        HStack {
                            Text("Bio")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(MapunaTheme.textSecondary)

                            Spacer()

                            Text("\(bio.count)/120")
                                .font(.system(size: 12))
                                .foregroundStyle(MapunaTheme.textSecondary)
                        }

                        TextEditor(text: $bio)
                            .scrollContentBackground(.hidden)
                            .foregroundStyle(MapunaTheme.textPrimary)
                            .frame(height: 130)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(MapunaTheme.card)
                            )
                            .onChange(of: bio) { _, newValue in
                                if newValue.count > 120 {
                                    bio = String(
                                        newValue.prefix(120)
                                    )
                                }
                            }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                    }

                    Button {
                        saveProfile()
                    } label: {

                        HStack {
                            Spacer()

                            if isSaving {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("Save changes")
                                    .font(.system(size: 17, weight: .bold))
                            }

                            Spacer()
                        }
                        .foregroundStyle(.black)
                        .frame(height: 56)
                        .background(MapunaTheme.lime)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .disabled(isSaving || cleanName.isEmpty)
                    .opacity(
                        cleanName.isEmpty ? 0.5 : 1
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var header: some View {
        HStack {

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(MapunaTheme.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(MapunaTheme.card)
                    )
            }

            Spacer()

            Text("Edit Profile")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(MapunaTheme.textPrimary)

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
    }

    private var cleanName: String {
        name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private func saveProfile() {

        errorMessage = nil

        guard !cleanName.isEmpty else {
            errorMessage = "Name cannot be empty."
            return
        }

        isSaving = true

        UserService.shared.updateProfile(
            uid: profile.uid,
            name: cleanName,
            bio: bio.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        ) { result in

            DispatchQueue.main.async {

                isSaving = false

                switch result {

                case .success:
                    onSaved()
                    dismiss()

                case .failure(let error):
                    errorMessage =
                        error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            profile: UserProfile(
                id: "preview",
                uid: "preview",
                name: "Rugeyye Çifci",
                username: "rugeyye",
                email: "example@gmail.com",
                photoURL: "",
                bio: "collecting places & memories 🌍",
                followerCount: 0,
                followingCount: 0
            ),
            onSaved: {}
        )
    }
}
