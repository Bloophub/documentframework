//
//  AlertSceneDelegate.swift
//  HexV2
//
//  Created by Alec Isherwood on 06/07/2021.
//

import UIKit

open class BANAlertSceneWindow: UIWindow {
    deinit{
        ALog.log_verbose("deinit BANAlertSceneWindow")
    }
}

open class BANAlertScene: UIWindowScene {
    deinit{
        ALog.log_verbose("deinit BANAlertScene")
    }
}

open class BANAlertSceneDelegate: UIResponder, UIWindowSceneDelegate {
    deinit{
        ALog.log_verbose("deinit BANAlertSceneDelegate")
    }
    public var window: UIWindow?
    var guid = UUID().uuidString
    
    public func sceneDidDisconnect(_ scene: UIScene) {
//
    }
    
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        var title   = ""
        var message = ""
        if let first = connectionOptions.userActivities.first {
            if let titlex = first.userInfo?["title"] as? String{
                title = titlex
            }
            if let messagex = first.userInfo?["message"] as? String{
                message = messagex
            }
            //session
        }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        //windowScene.activityItemsConfigurationSource

        guard !message.isEmpty else {
            ALog.log_error("no_messagex")
            BANSceneManager.close_scene(session)
            return
        }

        let window                                      = BANAlertSceneWindow(windowScene: windowScene)
        let alertVC                                     = BANAlertViewController()
        alertVC.alertTitle                              = title
        alertVC.alertMessage                            = message
        
//        let pref = EnumManager.app_appearance.get_pref().rawValue
//        if(pref == EnumManager.app_appearance.DarkMode.rawValue) {
//            window.overrideUserInterfaceStyle = .dark
//        }
//        if(pref == EnumManager.app_appearance.LightMode.rawValue) {
//            window.overrideUserInterfaceStyle = .light
//        }
        
        window.rootViewController                       = alertVC
        self.window                                     = window
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
//            titlebar.toolbarStyle    = .unifiedCompact
            titlebar.toolbar = nil
        }
        #endif
        windowScene.sizeRestrictions?.minimumSize       = CGSize(width: 320, height: 250)
        windowScene.sizeRestrictions?.maximumSize       = CGSize(width: 320, height: 250)
        
        window.makeKeyAndVisible()
    
        


    }
    
//    override func restoreUserActivityState(_ activity: NSUserActivity) {
//        ALog.log_verbose("State Store Function")
//    }
//    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
//        return nil
//    }

}
