//
//  TXTMonacoEditor.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import Foundation
import UIKit
import WebKit

//https://stackoverflow.com/questions/57048510/how-to-initialize-microsoft-monaco-editor-in-a-browser-using-simple-javascript-o
//https://microsoft.github.io/monaco-editor/playground.html#extending-language-services-configure-javascript-defaults
//https://microsoft.github.io/monaco-editor/api/modules/monaco.editor.html
//https://microsoft.github.io/monaco-editor/playground.html#creating-the-editor-hard-wrapping

class TXTEditorUIViewController : TXTBaseUIViewController {
    weak var lang_btn: UIBarButtonItem?
    weak var docdelegatex: TXTDocumentManagerProtocol?
    lazy var wk_webview: TXTEditorWKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let webViewx = TXTEditorWKWebView(frame: self.view.frame, configuration: webConfiguration)
        webViewx.allowsLinkPreview = false
        webViewx.loadHTMLString("", baseURL: nil)
        webViewx.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webViewx
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        build_ui()
        load_editor_html()
        NotificationCenter.default.addObserver(self, selector: #selector(changed_prefs), name: pref_noty, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
 #if targetEnvironment(macCatalyst)
         CatalystProxy.intercept_window_close_button(view.window)
//        let nww = view.window?.nsWindow
//        nww?.close()
 #endif
     }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    deinit{
        ALog.log_verbose("deinit TXTMonacoEditorUIViewController")
        release_editor()
    }
}

extension TXTEditorUIViewController {
    
    internal func load_editor_html(){
        do{
            guard let del   = docdelegatex  else { throw TXTError.error_doc }
            let js_conn     = del.get_js_connector()
            js_conn.register_connector(wk_webview)
            guard let edit_url = TXTAPPURLs.get_editor_url() else { throw TXTError.error_doc }
            try js_conn.load_url(edit_url)
        }catch{
            present_error(error)
        }
    }

    func editor_loaded_html(_ content: String, _ url: URL) async throws {
        ALog.log_verbose("editor_loaded_html")
//        guard let del = docdelegatex else { throw TXTError.error_doc }
//        let js_conn   = del.get_js_connector()
//        //update editor options > theme color
//        try await update_editor_options()
//        //update editor set content (js,html...
//        try await js_conn.set_js_content(content)
//        //update lang tp the correct one
//        let lang = TXTLang.check_ext(url.pathExtension.lowercased()) ?? TXTLang.html
//        try await change_lang(lang)
    }

//    internal func change_lang(_ lang: TXTLang) async throws{
//        guard let del = docdelegatex  else { return }
//        del.set_current_lang(lang)
//        lang_menu_update()
//        try await del.get_js_connector().set_js_lang(lang.rawValue)
//    }
    
    @objc func changed_prefs(_ noty: NSNotification){
        //reload editor
//        ALog.log_verbose("noty \(noty)")
//        if let str = noty.object as? String, str == pref_editor_preference {
//            Task{
//                do{
//                    try await update_editor_options()
//                }catch {
//                    present_error(error)
//                }
//            }
//        }
    }
//    
//    private func update_editor_options() async throws {
//        guard let del = docdelegatex, let pref = XPref.get_editor_preference() else { return }
//        let js_conn   = del.get_js_connector()
//        try await js_conn.update_js_editor(pref)
//    }
}


