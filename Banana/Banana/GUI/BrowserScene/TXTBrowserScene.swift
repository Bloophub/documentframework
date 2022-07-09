//
//  TXTBrowserScene1.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/8/22.
//

import UIKit

class TXTBrowserDocumentWindow: UIWindow {
    override init(windowScene: UIWindowScene){
        super.init(windowScene: windowScene)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        ALog.log_verbose("deinit TXTBrowserDocumentWindow \(self)")
    }

}

class TXTBrowserScene: UIWindowScene {
    override init(session: UISceneSession, connectionOptions: UIScene.ConnectionOptions){
        super.init(session: session, connectionOptions: connectionOptions)
    }

    deinit {
        //ALog.log_verbose("deinit BrowserScene \(String.pointer(session))")
    }

}

class TXTBrowserDocumentSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    
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
    
    
    var windowx: TXTBrowserDocumentWindow?
    let browser_controllerx = TXTDocumentBrowserViewController(forOpening: nil)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        

        let window                                      = TXTBrowserDocumentWindow(windowScene: windowScene)
        windowx                                         = window
//        browser_controllerx.browser_delegatex           = self
        window.rootViewController                       = browser_controllerx
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

//extension TXTBrowserDocumentSceneDelegate : TXTDocumentBrowserViewControllerProtocol {
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
