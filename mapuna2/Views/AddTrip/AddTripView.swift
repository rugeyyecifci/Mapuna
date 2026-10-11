import SwiftUI
import PhotosUI
import FirebaseAuth

struct AddTripView: View {

    @EnvironmentObject var appData: AppData
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCityID: String =
        MockData.cities.first?.id ?? ""

    @State private var startDate = Date()
    @State private var endDate = Date()

    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedPhotos: [UIImage] = []

    @State private var memory = ""

    @State private var isSaving = false
    @State private var errorMessage: String?

    private var selectedCity: City? {
        MockData.cities.first {
            $0.id == selectedCityID
        }
    }

    var body: some View {

        NavigationStack {

            ZStack {

                MapunaTheme.background
                    .ignoresSafeArea()

                ScrollView {

                    VStack(
                        alignment: .leading,
                        spacing: 26
                    ) {

                        titleSection

                        citySection

                        dateSection

                        memorySection

                        photoPlaceholder

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 13))
                                .foregroundStyle(.red)
                        }

                        saveButton
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(
                        MapunaTheme.textPrimary
                    )
                    .disabled(isSaving)
                }
            }
            .toolbarBackground(
                MapunaTheme.background,
                for: .navigationBar
            )
            .toolbarColorScheme(
                .dark,
                for: .navigationBar
            )
        }
    }

    // MARK: - Title

    private var titleSection: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text("mapuna.")
                .font(
                    .system(
                        size: 32,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.lime
                )

            Text("Add a trip")
                .font(
                    .system(
                        size: 30,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )

            Text("Add a place to your world.")
                .font(.system(size: 15))
                .foregroundStyle(
                    MapunaTheme.textSecondary
                )
        }
    }

    // MARK: - City

    private var citySection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            sectionTitle("Where did you go?")

            Menu {

                ForEach(MockData.cities) { city in

                    Button {

                        selectedCityID = city.id

                    } label: {

                        Text(
                            "\(city.name), \(city.country)"
                        )
                    }
                }

            } label: {

                HStack {

                    Image(
                        systemName: "mappin.circle.fill"
                    )
                    .font(.system(size: 22))
                    .foregroundStyle(
                        MapunaTheme.lime
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {

                        Text(
                            selectedCity?.name
                            ?? "Choose a city"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            MapunaTheme.textPrimary
                        )

                        if let selectedCity {

                            Text(selectedCity.country)
                                .font(
                                    .system(size: 14)
                                )
                                .foregroundStyle(
                                    MapunaTheme
                                        .textSecondary
                                )
                        }
                    }

                    Spacer()

                    Image(
                        systemName: "chevron.down"
                    )
                    .foregroundStyle(
                        MapunaTheme.textSecondary
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .fill(MapunaTheme.card)
                )
            }
        }
    }

    // MARK: - Date

    private var dateSection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            sectionTitle("When?")

            VStack(spacing: 0) {

                DatePicker(
                    "Start",
                    selection: $startDate,
                    displayedComponents: .date
                )
                .tint(MapunaTheme.lime)
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )
                .padding(16)

                Divider()
                    .overlay(
                        MapunaTheme
                            .textSecondary
                            .opacity(0.2)
                    )

                DatePicker(
                    "End",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
                .tint(MapunaTheme.lime)
                .foregroundStyle(
                    MapunaTheme.textPrimary
                )
                .padding(16)
            }
            .background(
                RoundedRectangle(
                    cornerRadius: 20
                )
                .fill(MapunaTheme.card)
            )
        }
    }

    // MARK: - Memory

    private var memorySection: some View {

        VStack(
            alignment: .leading,
            spacing: 10
        ) {

            sectionTitle("Memory")

            ZStack(
                alignment: .topLeading
            ) {

                TextEditor(text: $memory)
                    .scrollContentBackground(
                        .hidden
                    )
                    .foregroundStyle(
                        MapunaTheme.textPrimary
                    )
                    .frame(minHeight: 130)
                    .padding(10)

                if memory.isEmpty {

                    Text(
                        "What do you want to remember?"
                    )
                    .foregroundStyle(
                        MapunaTheme.textSecondary
                    )
                    .padding(
                        .horizontal,
                        15
                    )
                    .padding(
                        .vertical,
                        18
                    )
                    .allowsHitTesting(false)
                }
            }
            .background(
                RoundedRectangle(
                    cornerRadius: 20
                )
                .fill(MapunaTheme.card)
            )
        }
    }

    // MARK: - Photos

    private var photoPlaceholder: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            sectionTitle("Photos")

            PhotosPicker(
                selection: $selectedPhotoItems,
                maxSelectionCount: 10,
                matching: .images
            ) {

                HStack(spacing: 14) {

                    ZStack {

                        RoundedRectangle(
                            cornerRadius: 14
                        )
                        .fill(
                            MapunaTheme.secondaryCard
                        )
                        .frame(
                            width: 58,
                            height: 58
                        )

                        Image(
                            systemName:
                                "photo.badge.plus"
                        )
                        .font(
                            .system(size: 22)
                        )
                        .foregroundStyle(
                            MapunaTheme.lime
                        )
                    }

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {

                        Text(
                            selectedPhotos.isEmpty
                            ? "Add photos"
                            : "\(selectedPhotos.count) photos selected"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            MapunaTheme.textPrimary
                        )

                        Text("Up to 10 photos")
                            .font(
                                .system(size: 14)
                            )
                            .foregroundStyle(
                                MapunaTheme
                                    .textSecondary
                            )
                    }

                    Spacer()

                    Image(
                        systemName: "chevron.right"
                    )
                    .foregroundStyle(
                        MapunaTheme.textSecondary
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20
                    )
                    .fill(MapunaTheme.card)
                )
            }

            if !selectedPhotos.isEmpty {

                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {

                    HStack(spacing: 10) {

                        ForEach(
                            Array(
                                selectedPhotos
                                    .enumerated()
                            ),
                            id: \.offset
                        ) { index, image in

                            ZStack(
                                alignment: .topTrailing
                            ) {

                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: 110,
                                        height: 130
                                    )
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 18
                                        )
                                    )
                                    .clipped()

                                Button {

                                    removePhoto(
                                        at: index
                                    )

                                } label: {

                                    Image(
                                        systemName:
                                            "xmark"
                                    )
                                    .font(
                                        .system(
                                            size: 11,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(
                                        .white
                                    )
                                    .frame(
                                        width: 26,
                                        height: 26
                                    )
                                    .background(
                                        .black
                                            .opacity(0.7)
                                    )
                                    .clipShape(
                                        Circle()
                                    )
                                }
                                .padding(7)
                            }
                        }
                    }
                }
            }
        }
        .onChange(
            of: selectedPhotoItems
        ) {
            loadSelectedPhotos()
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {

        Button {

            saveTrip()

        } label: {

            HStack {

                if isSaving {

                    ProgressView()
                        .tint(.black)

                    Text("Saving...")

                } else {

                    Image(
                        systemName: "plus"
                    )

                    Text("Add to Mapuna")
                }
            }
            .font(
                .system(
                    size: 17,
                    weight: .bold
                )
            )
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                MapunaTheme.lime
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
        }
        .disabled(isSaving)
        .opacity(
            isSaving ? 0.7 : 1
        )
    }

    // MARK: - Helpers

    private func sectionTitle(
        _ title: String
    ) -> some View {

        Text(title)
            .font(
                .system(
                    size: 20,
                    weight: .bold
                )
            )
            .foregroundStyle(
                MapunaTheme.textPrimary
            )
    }

    private func loadSelectedPhotos() {

        Task {

            var images: [UIImage] = []

            for item in selectedPhotoItems {

                if let data =
                    try? await item
                        .loadTransferable(
                            type: Data.self
                        ),
                   let image =
                    UIImage(data: data) {

                    images.append(image)
                }
            }

            await MainActor.run {
                selectedPhotos = images
            }
        }
    }

    private func removePhoto(
        at index: Int
    ) {

        guard selectedPhotos.indices
            .contains(index)
        else {
            return
        }

        selectedPhotos.remove(
            at: index
        )

        if selectedPhotoItems.indices
            .contains(index) {

            selectedPhotoItems.remove(
                at: index
            )
        }
    }

    // MARK: - Save Trip

    private func saveTrip() {

        errorMessage = nil

        guard let selectedCity else {
            errorMessage =
                "Please choose a city."
            return
        }

        guard let uid =
            Auth.auth().currentUser?.uid
        else {
            errorMessage =
                "User is not logged in."
            return
        }

        isSaving = true

        let newTrip = Trip(
            id: UUID().uuidString,
            userID: uid,
            title: "\(selectedCity.name) Trip",
            city: selectedCity,
            startDate: startDate,
            endDate: endDate,
            note: memory.isEmpty
                ? nil
                : memory,
            photoURLs: [],
            likeCount: 0,
            commentCount: 0,
            createdAt: Date()
        )

        TripService.shared.addTrip(
            newTrip
        ) { result in

            DispatchQueue.main.async {

                isSaving = false

                switch result {

                case .success:

                    appData.addTrip(
                        newTrip
                    )

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
    AddTripView()
        .environmentObject(
            AppData()
        )
}
