import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()

        return true
    }
}

@main
struct mapuna2App: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var delegate

    @StateObject private var appData = AppData()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appData)
        }
    }
}
