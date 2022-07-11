//
//  TXTBrowserScene.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import Foundation
import UIKit

open class BANDocumentSceneWindow: UIWindow {
    override init(windowScene: UIWindowScene){
        super.init(windowScene: windowScene)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        ALog.log_verbose("deinit BANDocumentSceneWindow")
    }

    
#if targetEnvironment(macCatalyst)
    @objc func _close(_ sender: Any?){
        guard let wi_sc = windowScene as? BANDocumentScene,
              let doc_del = wi_sc.delegate as? BANDocumentSceneDelegate,
              let doc_int = doc_del.get_doc_int_manager() else{
            return
        }
        Task{
            guard await doc_int.close_save_docx() else { return }
            nsWindow?._close(sender)
        }
    }
#endif


}

open class BANDocumentScene: UIWindowScene {
    var my_next: UIResponder?
    override public var next: UIResponder? { get {
        if let my_nextx = my_next {
            return my_nextx
        }
        return super.next
    }}

    override init(session: UISceneSession, connectionOptions: UIScene.ConnectionOptions){
        super.init(session: session, connectionOptions: connectionOptions)
    }

    deinit {
        ALog.log_verbose("deinit BANDocumentScene")
    }
}
open class BANDocumentSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    deinit {
        ALog.log_verbose("deinit BANDocumentSceneDelegate")
    }

    private var doc_int_manager: BANDocumentInterfaceManager?
    var my_next: UIResponder?
    override public var next: UIResponder? { get {
        if let my_nextx = my_next {
            return my_nextx
        }
        return super.next
    }}
    

    public func sceneDidDisconnect(_ scene: UIScene) {
        ALog.log_verbose("TXTDocumentSceneDelegate sceneDidDisconnect \(scene.session.configuration.name ?? "")")
    }
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach { uc in
            BANSceneManager.open_url(uc.url)
        }
    }
    
    
    public func get_doc_int_manager() -> BANDocumentInterfaceManager?{
        doc_int_manager
    }
    
    open func build_doc_int_manager(_ url: URL) -> BANDocumentInterfaceManager{
        BANDocumentInterfaceManager(url)
    }
    
    public func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        get_user_activity()
    }
    
    public func get_user_activity() -> NSUserActivity?{
        guard let url           = doc_int_manager?.get_doc_url() else  { return  nil }
        let userActivity        = NSUserActivity(activityType: BANActivityIdentifier.document.rawValue)
        userActivity.title      = url.lastPathComponent
        userActivity.userInfo   = [BANSceneKeys.xdoc_url.rawValue:url]
        return userActivity
    }
        
    public var windowx: BANDocumentSceneWindow?
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        var doc_url: URL?
        //useractivity
        let act = connectionOptions.userActivities.first ?? session.stateRestorationActivity
        if let first = act, let doc_path = first.userInfo?[BANSceneKeys.xdoc_url.rawValue] as? String{
            doc_url = URL(fileURLWithPath: doc_path)
            //session
        } else if let userinfo = session.userInfo, let doc_path = userinfo[BANSceneKeys.xdoc_url.rawValue] as? String {
            doc_url = URL(fileURLWithPath: doc_path)
        }
        
        guard let doc_urlx = doc_url else {
            ALog.log_error("no url doc")
            BANSceneManager.close_scene(session)
            return
        }
        
        
        let window              = BANDocumentSceneWindow(windowScene: windowScene)
        windowx                 = window
        
        windowScene.userActivity = get_user_activity()
        windowScene.userActivity?.needsSave = true

        window.userActivity = get_user_activity()
        window.userActivity?.needsSave = true


        let doc_int_managerx    = build_doc_int_manager(doc_urlx)
        doc_int_manager         = doc_int_managerx
//        let nav                 = UINavigationController(rootViewController: doc_int_managerx.editor_vc)
        //RESPONDER
        //"TXTDocumentSceneWindow:false\n -> TXTDocumentScene:false\n -> UIApplication:false\n -> AppDelegate:false\n"
        
        // "UINavigationController:false\n -> UIDropShadowView:false\n -> UITransitionView:false\n ->
        // TXTDocumentSceneWindow:false\n -> TXTDocumentScene:false\n -> UIApplication:false\n -> AppDelegate:false\n"
        if let doc_scene = windowScene as? BANDocumentScene {
            let app_responder_next      = doc_scene.next         //saving original responder
            doc_scene.my_next           = doc_int_manager   //set scene_delegate as next of the doc_scene
            doc_int_managerx.my_next    = app_responder_next //set uiapp as next of doc_int_manager
        }
        
        
        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1200, height: 900)

        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            titlebar.representedURL = doc_url
            windowScene.title = doc_urlx.lastPathComponent
//            toolbar.allowsUserCustomization = true
//            toolbar.autosavesConfiguration = true
//            toolbar.showsBaselineSeparator = true
//            toolbar.delegate    = toolbarDelegate
//            toolbar.displayMode = .iconAndLabel
//            toolbarDelegate.documentInterfaceToolbarDelegate = self
//            toolbarDelegate.toolbarSearchDelegate = doc_int_manager.ext_editor_vc
//            WebviewToolbarDelegate = doc_int_manager.ext_webview_vc
//            titlebar.toolbar = toolbar
        }
        #endif

        let nav = doc_int_managerx.build_gui()
        window.rootViewController  = nav
        window.makeKeyAndVisible()

    }
    
//    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
//        return nil
//    }
}

//extension TXTBrowserDocumentSceneDelegate : TXTDocumentBrowserViewControllerProtocol {
//    func browser_get_current_scene() -> UIScene? {
//        return windowx?.windowScene
//    }
//}
