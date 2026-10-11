# 🌍 Mapuna

### Your world, your journeys, your memories.

**Mapuna** is an iOS travel journal application built with SwiftUI. It allows users to track visited cities, save travel memories, and visualize their journeys on an interactive map.

The goal of Mapuna is to make exploring and remembering the world a more personal and enjoyable experience.

**🚧 Status: Work in Progress — Actively Developing**

---

## 📱 Features

- **Google Authentication:** Secure user sign-in using Firebase Authentication.
- **Interactive Travel Map:** Explore visited destinations with MapKit.
- **Trip Management:** Create, view, and delete personal travel records.
- **Cloud Synchronization:** Store and retrieve travel data using Cloud Firestore.
- **Personal Profiles:** Customize your display name and biography.
- **Travel Statistics:** Track the number of trips, countries, and cities visited.
- **Photo Selection:** Select and preview travel photos within the app.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Swift | Programming language |
| SwiftUI | User interface |
| MapKit | Interactive maps |
| Firebase Authentication | Google Sign-In |
| Cloud Firestore | Cloud database |
| Xcode | iOS development |

## 📸 Screenshots

*Application screenshots will be added as development progresses.*

Planned screenshots:
- Home Screen
- Interactive Map
- My Trips
- User Profile

## 🏗️ Architecture

The project separates its functionality into reusable components, models, views, view models, and services.

Firebase services handle user authentication, profile management, and trip data persistence.

SwiftUI provides a declarative and modular user interface.

## 🚀 Getting Started

1. Clone the repository.
2. Open `mapuna2.xcodeproj` in Xcode.
3. Configure your own Firebase project with Authentication and Cloud Firestore.
4. Download your Firebase iOS configuration file, `GoogleService-Info.plist`, and add it to the appropriate Xcode target.
5. Configure Google Sign-In for your Firebase project and iOS application.
6. Build and run the application on an iOS simulator or device.

**Note:** Firebase configuration files are excluded from version control. A personal Firebase setup is required to run the app.

## 🔮 Roadmap

- [x] Google Sign-In
- [x] User profile creation
- [x] Edit profile
- [x] Add and delete trips
- [x] Firestore trip persistence
- [x] MapKit integration
- [x] Travel statistics
- [ ] Upload photos to cloud storage
- [ ] Edit existing trips
- [ ] Search for destinations
- [ ] Follow other travelers
- [ ] Share travel experiences
- [ ] UI/UX refinements

## 🎯 Project Goals

Mapuna is an ongoing personal software engineering project focused on developing practical experience with native iOS development, cloud databases, authentication, and scalable application architecture.
