import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  /*
   {
     apiKey: "AIzaSyBukJRUN9wfHFnZc_fjBRRHNsLSCTxqhGQ",
     authDomain: "lansing-codes-staging.firebaseapp.com",
     databaseURL: "https://lansing-codes-staging.firebaseio.com",
     projectId: "lansing-codes-staging",
     storageBucket: "lansing-codes-staging.appspot.com",
     messagingSenderId: "36794992743",
     appId: "1:36794992743:web:2350879a650f171e"
   }
   */

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
//
//
//    db.collection("groups").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            for document in querySnapshot!.documents {
//
//                print("\(document.documentID) => \(document.data())")
//            }
//        }
//    }
//    db.collection("events").getDocuments() { (querySnapshot, err) in
//           if let err = err {
//               print("Error getting documents: \(err)")
//           } else {
//               for document in querySnapshot!.documents {
//                   print("\(document.documentID) => \(document.data())")
//               }
//           }
//       }
//    db.collection("sponsors").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            for document in querySnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
//            }
//        }
//    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
