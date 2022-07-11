//
//  BANBrowserScene1.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/8/22.
//

import UIKit

open class BANBrowserDocumentWindow: UIWindow {
    override init(windowScene: UIWindowScene){
        super.init(windowScene: windowScene)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        ALog.log_verbose("deinit BANBrowserDocumentWindow \(self)")
    }

}

open class BANBrowserScene: UIWindowScene {
    override init(session: UISceneSession, connectionOptions: UIScene.ConnectionOptions){
        super.init(session: session, connectionOptions: connectionOptions)
    }

    deinit {
        ALog.log_verbose("deinit BrowserScene")
    }

}

open class BANBrowserDocumentSceneDelegate: UIResponder, UIWindowSceneDelegate {
    deinit {
        ALog.log_verbose("BANBrowserDocumentSceneDelegate deinit")
    }
    
    public func sceneDidDisconnect(_ scene: UIScene) {
        //ALog.log_verbose("BrowserDocumentSceneDelegate sceneDidDisconnect \(scene.session.configuration.name ?? "")")
    }
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { uc in
            BANSceneManager.open_url(uc.url)
        }
    }

    open func get_browser_root_view_controller() -> BANDocumentBrowserViewController {
        return BANDocumentBrowserViewController(forOpening: nil)
    }
    
    public var windowx: BANBrowserDocumentWindow?
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        ALog.log_verbose("connectionOptions")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        

        let window                                      = BANBrowserDocumentWindow(windowScene: windowScene)
        windowx                                         = window
        window.rootViewController                       = get_browser_root_view_controller()
        window.makeKeyAndVisible()
        windowScene.title   = "Browser"
//        #if targetEnvironment(macCatalyst)
////        if let titlebar = windowScene.titlebar {
////            titlebar.titleVisibility = .hidden
////            titlebar.toolbar = nil
////        }
////        windowScene.sizeRestrictions?.minimumSize       = CGSize(width: 590, height: 340)
////        windowScene.sizeRestrictions?.maximumSize       = CGSize(width: 590, height: 340)
//        #endif

    }
    
//    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
//        return nil
//    }
}

//extension BANBrowserDocumentSceneDelegate : TXTDocumentBrowserViewControllerProtocol {
//    func browser_present_doc(_ documentURL: URL) {
//        //present doc in another window catalyst mode
//        TXTSceneManager.open_doc_scene(self.windowx?.windowScene,documentURL)
//    }
//    
////    func browser_get_current_scene() -> UIScene? {
////        return windowx?.windowScene
////    }
//
//}
