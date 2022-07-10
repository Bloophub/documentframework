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

open class BANEditorUIViewController : BANBaseUIViewController {
    weak open var docdelegatex: BANDocumentManagerProtocol?
    open lazy var wk_webview: BANEditorWKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let webViewx = BANEditorWKWebView(frame: self.view.frame, configuration: webConfiguration)
        webViewx.allowsLinkPreview = false
        webViewx.loadHTMLString("", baseURL: nil)
        webViewx.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webViewx
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        editor_did_load()
    }

    
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 #if targetEnvironment(macCatalyst)
         BANCatalystProxy.intercept_window_close_button(view.window)
//        let nww = view.window?.nsWindow
//        nww?.close()
 #endif
     }

    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    deinit{
        ALog.log_verbose("deinit BANEditorUIViewController")
        release_editor()
    }
    
    open func editor_did_load(){
        build_ui()
        load_editor_html()
        add_observers()
    }
    
    open func add_observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(changed_prefs), name: pref_noty, object: nil)
    }
}

//MARK: - LOAD
extension BANEditorUIViewController {
    
    internal func load_editor_html(){
        do{
            guard let del   = docdelegatex  else { throw BANError.error_doc }
            let js_conn     = del.get_js_connector()
            js_conn.register_connector(wk_webview)
            guard let edit_url = BANAppUrls.get_editor_url() else { throw BANError.error_doc }
            try js_conn.load_url(edit_url)
        }catch{
            present_error(error)
        }
    }

    @objc open func editor_loaded_html(_ content: String, _ url: URL) async throws {
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
    
    @objc open func changed_prefs(_ noty: NSNotification){
        //reload editor

    }
}


extension BANEditorUIViewController {

    @objc open func build_ui(){
        
        view.backgroundColor = .systemBackground
//        self.title = "Text Editor"
//        view.backgroundColor = .red

        //LEFT
        if !BANPlatform.isCatalyst {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save_btn))
        }

        //RIGHT
        var rb              = [UIBarButtonItem]()
        if !BANPlatform.isCatalyst {
            let close_btn   = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close_editor_btn))
            rb.append(close_btn)
        }


        navigationItem.rightBarButtonItems = rb.reversed()

        BANEditorWKWebView.clean_cookie()
        view.addSubview(wk_webview)
        wk_webview.util_fill_superview()
    }

    
    open func release_editor(){
        guard let del   = docdelegatex  else { return }
        let js_conn     = del.get_js_connector()
        js_conn.unregister_connector()
        wk_webview.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc open func close_editor_btn(_ sender: Any?){
        guard let del   = docdelegatex  else { return }
        Task{
            guard await del.doc_will_close() else { return }
            if !BANPlatform.isCatalyst {
                dismiss(animated: true)
            }
        }
    }

    @objc open func save_btn(_ sender: Any?){
        guard let del = docdelegatex  else { return }
        Task{ //Task.detached{
            await del.doc_will_save()
        }
    }

}

//MARK: - WKWEBVIEW
open class BANEditorWKWebView: WKWebView {
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configure_wk_ui()
    }
    
    deinit{
        ALog.log_verbose("deinit TXTMonacoEditorWKWebView")
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure_wk_ui(){
        isOpaque = false
        backgroundColor = UIColor.clear

//        backgroundColor                             = UIColor.systemBackground
        scrollView.bounces                          = false
        scrollView.zoomScale                        = 1
//        scrollView.maximumZoomScale                 = 1
//        scrollView.minimumZoomScale                 = 1
//        scrollView.isScrollEnabled                  = false
        scrollView.showsVerticalScrollIndicator     = false
        scrollView.showsHorizontalScrollIndicator   = false

    }
    
    open override var canBecomeFirstResponder: Bool{
        return true
    }

    class func clean_cookie(){
        let store: WKWebsiteDataStore = WKWebsiteDataStore.default()
        let dataTypes: Set<String> = WKWebsiteDataStore.allWebsiteDataTypes()
        store.fetchDataRecords(ofTypes: dataTypes, completionHandler: { (records: [WKWebsiteDataRecord]) in
            store.removeData(ofTypes: dataTypes, for: records, completionHandler: {
          })
        })

    }
}

