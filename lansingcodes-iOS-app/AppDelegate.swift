import BackgroundTasks
import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.brightdigit.lansingcodes-iOS-app.events", using: nil) { _ in
    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_: UIApplication,
                   didDiscardSceneSessions _: Set<UISceneSession>) {}
}
