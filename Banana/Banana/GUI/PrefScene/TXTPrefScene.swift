//
//  PrefSceneDelegate.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/8/22.
//

import UIKit

import UIKit

class TXTPrefSceneWindow: UIWindow {
    override init(windowScene: UIWindowScene){
        super.init(windowScene: windowScene)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
//        rootViewController = UIViewController()
        //ALog.log_verbose("deinit BrowserDocumentWindow \(rootViewController) \(String.pointer(windowScene?.session))")
    }

}

class TXTPrefSceneScene: UIWindowScene {
    override init(session: UISceneSession, connectionOptions: UIScene.ConnectionOptions){
        super.init(session: session, connectionOptions: connectionOptions)
    }

    deinit {
        //ALog.log_verbose("deinit BrowserScene \(String.pointer(session))")
    }

}

class TXTPrefSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    
    deinit {
        //ALog.log_verbose("BrowserDocumentSceneDelegate deinit")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        //ALog.log_verbose("BrowserDocumentSceneDelegate sceneDidDisconnect \(scene.session.configuration.name ?? "")")
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { uc in
            TXTSceneManager.open_url(uc.url)
        }
    }
    
    
    var windowx: TXTPrefSceneWindow?
    let prefs = TXTPreferenceUITableViewController(style: .insetGrouped)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let nav             = UINavigationController(rootViewController: prefs)
        let window          = TXTPrefSceneWindow(windowScene: windowScene)
        windowx             = window
        windowScene.title   = "Settings"
        #if targetEnvironment(macCatalyst)
//        if let titlebar = windowScene.titlebar {
//            titlebar.titleVisibility = .hidden
//            titlebar.toolbar = nil
//        }
        windowScene.sizeRestrictions?.minimumSize       = CGSize(width: 590, height: 340)
        windowScene.sizeRestrictions?.maximumSize       = CGSize(width: 590, height: 340)
        #endif
        window.rootViewController                       = nav
        window.makeKeyAndVisible()
    }
    

}

