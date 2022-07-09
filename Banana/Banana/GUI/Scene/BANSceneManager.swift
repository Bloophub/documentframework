//
//  TXTSceneManager.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/8/22.
//

import UIKit

enum BANActivityIdentifier: String {
    case document          = "document"
    case file_browser      = "file_browser"
    case preferences       = "preferences"
    case alert_window      = "alert_window"

    func sceneConfiguration() -> UISceneConfiguration {
        switch self {
        case .document:
            return UISceneConfiguration(
                name: BANSceneConfiguration.document_config.rawValue,
                sessionRole: .windowApplication
            )
        case .file_browser:
            return UISceneConfiguration(
                name: BANSceneConfiguration.default_config.rawValue,
                sessionRole: .windowApplication
            )
        case .preferences:
            return UISceneConfiguration(
                name: BANSceneConfiguration.preferences_config.rawValue,
                sessionRole: .windowApplication
            )
        case .alert_window:
            return UISceneConfiguration(
                name: BANSceneConfiguration.alert_config.rawValue,
                sessionRole: .windowApplication
            )
        }
    }
}


enum BANSceneConfiguration: String{
    case alert_config           = "Alert Configuration"
    case document_config        = "Document Configuration"
//    case new_document_config    = "New Document Configuration"
    case default_config         = "Default Configuration"
    case preferences_config     = "Preferences Configuration"
}

enum BANSceneKeys: String{
    case doc_url            = "doc_url"
    case open_url           = "open_url"
    
}
//https://gist.github.com/steipete/40a367b64b57bfd0b44fa8d158fc016c
@MainActor
class BANSceneManager {

    static func get_app_file_types() -> [String] {
        return []
    }
    
    static func get_editor_scenes() -> [BANDocumentScene] {
        return UIApplication.shared.connectedScenes.compactMap { scene in
            scene as? BANDocumentScene
        }
//        var documentScenes: [TXTDocumentScene] = []
//        UIApplication.shared.connectedScenes.forEach { scene in
//            guard let docAsScene = scene as? TXTDocumentScene else { return }
//            documentScenes.append(docAsScene)
//        }
//        return documentScenes
    }

    static func file_browser_scene() -> UIWindowScene?{
        return UIApplication.shared.connectedScenes.first { scene in
            //            if let wsc = scene as? UIWindowScene {
            //                wsc.windows.forEach { win in
            //                    win.backgroundColor = .red
            //                    ALog.log_verbose("\(win)")
            //                }
            //            }
            return scene.session.configuration.name == BANSceneConfiguration.default_config.rawValue
        } as? UIWindowScene
    }

    static func preferences_scene() -> UIWindowScene?{
        return UIApplication.shared.connectedScenes.first { scene in
            return scene.session.configuration.name == BANSceneConfiguration.preferences_config.rawValue
        } as? UIWindowScene
    }

    private static func open_preferences_scene(_ vc: UIViewController?, _ errorHandler: ((Error) -> Void)? = nil){
        if let vcx = vc, !Platform.isCatalyst {
            let pref    = BANPreferenceUITableViewController( style: .insetGrouped)
            let nav     = UINavigationController(rootViewController: pref)
            vcx.present(nav,animated: true)
            return
        }
        if preferences_scene() != nil {
            return
        }
        let activity = NSUserActivity(activityType: BANActivityIdentifier.preferences.rawValue)
        activity.addUserInfoEntries(from: ["viaMenu":"true"])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: errorHandler)
    }

    static func open_file_browser_scene(_ errorHandler: ((Error) -> Void)? = nil){
        if file_browser_scene() != nil {
            return
        }
        let activity = NSUserActivity(activityType: BANActivityIdentifier.file_browser.rawValue)
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: errorHandler)
    }

    
    static func open_doc_scene( _ scene: UIWindowScene?,_ url: URL) {
        if doc_scene(url) != nil{
            return
        }
        if let sc = scene {
            close_scene(sc.session)
        }
        let userActivity = NSUserActivity(activityType: BANActivityIdentifier.document.rawValue)
        userActivity.userInfo = [BANSceneKeys.doc_url.rawValue:url.path]
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
    
    static func doc_scene(_ url: URL) -> UIWindowScene? {
        let ws = UIApplication.shared.connectedScenes.first { scene in
            if scene.session.configuration.name == BANSceneConfiguration.document_config.rawValue,
               let bd = scene.delegate as? BANDocumentSceneDelegate {
                let doc_int = bd.get_doc_int_manager()
                if doc_int?.get_doc_url() == url {
                    return true
                }
            }
            return false
        } as? UIWindowScene
        return ws
    }
    
    
    @discardableResult static func open_url(_ url: URL) -> Bool{
        let browser_controllerx = BANDocumentBrowserViewController(forOpening: nil) // was nil -> [.html]
        browser_controllerx.presentDocument(at: url)
        return true
    }
    
    
    static func show_pref_menu(_ vc: UIViewController? = nil) {
        if Platform.isCatalyst {
            open_preferences_scene(nil)
            return
        }
        if let vcx = vc {
            open_preferences_scene(vcx)
        }
        //hedge case called without VC find the current editor
        else if let del = UIApplication.get_key_window()?.windowScene?.delegate as? BANBrowserDocumentSceneDelegate,
                let doc_int = del.browser_controllerx.doc_int_manager  {
            doc_int.show_doc_int_pref()
        }
    }
    
    static func close_scene(_ session: UISceneSession, _ errorHandler: ((Error) -> Void)? = nil) {
        UIApplication.shared.requestSceneSessionDestruction(session, options: nil) { err_destroy in
            ALog.log_error("close_scene \(err_destroy) \(session)")
            errorHandler?(err_destroy)
        }
    }
    
#if targetEnvironment(macCatalyst)
    static func open_alert_scene(_ title: String, _ message: String, _ errorHandler: ((Error) -> Void)? = nil){
        let activity = NSUserActivity(activityType: BANActivityIdentifier.alert_window.rawValue)
        activity.addUserInfoEntries(from: ["title" : title])
        activity.addUserInfoEntries(from: ["message" : message])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: errorHandler)
    }
    static func open_alert_error_scene(_ title: String, _ error: Error, _ errorHandler: ((Error) -> Void)? = nil){
        let activity = NSUserActivity(activityType: BANActivityIdentifier.alert_window.rawValue)
        activity.addUserInfoEntries(from: ["title" : title])
        activity.addUserInfoEntries(from: ["message" : error.localizedDescription])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: activity, options: nil, errorHandler: errorHandler)
    }
#endif

#if targetEnvironment(macCatalyst)
    static func new_doc() throws{
        let file_types: [String] = get_app_file_types()
        guard let existing_document_url: URL = TXTAPPURLs.basic_document_url() else {
            ALog.log_error("new_doc basic_document_url")
            throw BANError.error_doc
        }

        let file_name = "";
        guard let new_doc_url = BANCatalystProxy.save_modal_panel(file_name,file_types) else {
            ALog.log_error("new_doc save_modal_panel")
            throw BANError.error_doc
        }

        guard new_doc_url.startAccessingSecurityScopedResource() else {
            ALog.log_error("new_doc_url startAccessingSecurityScopedResource1")
            throw BANError.error_doc
        }
        
        var new_doc_url2 = new_doc_url
        if new_doc_url.pathExtension.isEmpty {
            new_doc_url2.appendPathExtension("html")
        }
        guard new_doc_url2.startAccessingSecurityScopedResource() else {
            ALog.log_error("new_doc_url2 startAccessingSecurityScopedResource2")
            throw BANError.error_doc
        }
        new_doc_url.stopAccessingSecurityScopedResource()
        if FileManager.default.fileExists(atPath: new_doc_url2.path) {
            try FileManager.default.removeItem(atPath: new_doc_url2.path)
        }
//        FileManager.default.createFile(atPath: new_doc_url2.path, contents: "".data(using: .utf8))
//        let dbvc = TXTDocumentBrowserViewController(forOpening: nil)
        let data = try Data(contentsOf: existing_document_url)
        try data.write(to: new_doc_url2)
        BANSceneManager.open_doc_scene(nil,new_doc_url2)
//        dbvc.presentDocument(at: new_doc_url2.absoluteURL)

    }
#endif
}
