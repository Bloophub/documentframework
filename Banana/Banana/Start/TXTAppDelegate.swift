//
//  AppDelegate.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import UIKit

@main
class TXTAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ALog.create_logger(env: environment)

        do {
            try TXTAPPURLs.create_urls()
        }catch {
            ALog.log_error("create_urls() error: \(error)")
        }
        ALog.log_verbose("BaseURL: \(String(describing: TXTAPPURLs.base_url))")
        
        DispatchQueue.main.async {
            XPref.update_appearance()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    //MARK: - MENU
    private var menu_controller: TXTAppMenu?
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == .main {
            menu_controller = TXTAppMenu(with: builder)
        }
    }
    
    //MARK: - SCENE
    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard inputURL.isFileURL else { return false }
        return TXTSceneManager.open_url(inputURL)
    }
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        

        if let docUrl = options.urlContexts.first {
            let sceneConfig = TXTActivityIdentifier.document.sceneConfiguration()
            connectingSceneSession.userInfo  = [TXTSceneKeys.doc_url.rawValue :docUrl.url.path]
            return sceneConfig
        }

        var currentActivityIdentifier: TXTActivityIdentifier? = nil
        if let first = options.userActivities.first {
            currentActivityIdentifier = TXTActivityIdentifier(rawValue: first.activityType)
        }

        if let activity = currentActivityIdentifier {
            return activity.sceneConfiguration()
        }
        let activity    = currentActivityIdentifier ?? TXTActivityIdentifier.file_browser
        let sceneConfig = activity.sceneConfiguration()
        return sceneConfig
    }

}

