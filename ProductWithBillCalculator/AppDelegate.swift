//
//  AppDelegate.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate,SWRevealViewControllerDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    var isFirstTime:Bool = false
    var isProductFromSiri:Bool = false
    var selectedViewController:TaSelectedLocalNotification?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        isFirstTime = true
       
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
//        self.window?.makeKeyAndVisible()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.setUpValidation()
        IAPManager.shared.startObserving()
        FirebaseApp.configure()
        self.window?.makeKeyAndVisible()
       
        return true
    }

    func setUpValidation() {
        let email = KeychainService.loadEmail()
        if email.isEmpty {
            self.restoreFromStore(backupName:kProductDataBase)
        }
        if let email = UserDefaults.standard.value(forKey: kEmail) {
            let emailData = email as! String
            if emailData.count > 3 {
                UserDefaults.standard.set(true, forKey: kLogin)
            } else {
                UserDefaults.standard.set(false, forKey: kLogin)
            }
        }
        if ((UserDefaults.standard.value(forKey: kTheamColor)) != nil) {
            strTheamColor = UserDefaults.standard.value(forKey: kTheamColor) as! String
        }
        if UserDefaults.standard.value(forKey: kSelectedLanguage) != nil {
            strSelectedLanguage = UserDefaults.standard.value(forKey: kSelectedLanguage) as! String
            strSelectedLocal = UserDefaults.standard.value(forKey: kSelectedLocal) as! String
        }
        if UserDefaults.standard.value(forKey: kSpeach) == nil {
            UserDefaults.standard.set(false, forKey: kSpeach)
            UserDefaults.standard.synchronize()
        }
        if UserDefaults.standard.value(forKey: kSpeakSpeech) == nil {
            UserDefaults.standard.set(false, forKey: kSpeakSpeech)
            isSpeackSpeechOn = false
            UserDefaults.standard.synchronize()
        } else {
            isSpeackSpeechOn = UserDefaults.standard.value(forKey: kSpeakSpeech) as! Bool
        }
     
        let storyboard = UIStoryboard(name: MainStoryBoard, bundle: nil)
        if (UserDefaults.standard.bool(forKey: kLogin)) {
            let value = UserDefaults.standard.value(forKey: kLogin) as! Bool
            if value {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            //  navigationController.viewControllers = [initialViewController]
        } else{
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPManager.shared.stopObserving()
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func restoreFromStore(backupName: String){
        DispatchQueue.global(qos: .userInitiated).async {
//            let pred = NSPredicate(value: true)
//            let query = CKQuery(recordType: "CD_BusinessDetails", predicate: pred)
//            let operation = CKQueryOperation(query: query)
//            operation.recordFetchedBlock = { record in
//            }
//            CKContainer.default().publicCloudDatabase.add(operation)
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ProductWithBillCalculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
extension AppDelegate:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       let userInfo = notification.request.content
        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: userInfo.body)
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        selectedViewController!(userInfo.title, userInfo.subtitle)
        completionHandler()
    }
}
