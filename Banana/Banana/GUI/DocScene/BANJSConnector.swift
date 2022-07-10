//
//  TXTJSConnector.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import Foundation
import UIKit
import WebKit

open class BANJSConnector: NSObject {
    weak var web_view: WKWebView?
    weak var docdelegatex: BANDocumentManagerProtocol?
    
    @MainActor
    @discardableResult func load_html(_ html: String) throws -> WKNavigation? {
        guard let wv = self.web_view else {
            throw BANError.no_webview
        }
        return wv.loadHTMLString(html, baseURL: nil)
    }
    
    
    @MainActor
    @discardableResult public func load_url(_ urlx: URL?) throws -> WKNavigation?{
        guard let wv = self.web_view else {
            throw BANError.no_webview
        }
        guard let url = urlx else {
            throw BANError.missing_url
        }
        if wv.isLoading {
            wv.stopLoading()
        }
        return wv.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
    
    
    public func get_js_content() async throws -> String? {
        try await run_editor_js("get_content()") as? String
    }
}

extension BANJSConnector: WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    public func unregister_connector(){
        guard let wv = self.web_view else {
            self.docdelegatex?.present_error(BANError.no_webview)
            return
        }
        wv.configuration.userContentController.removeAllUserScripts()
        wv.configuration.userContentController.removeAllScriptMessageHandlers()
        wv.uiDelegate = nil
        wv.navigationDelegate = nil
        self.web_view = nil
        self.docdelegatex = nil 
    }
    
    public func register_connector(_ web_view: WKWebView){
        self.web_view = web_view
        let contentController = web_view.configuration.userContentController
        contentController.add(self, name: "scriptlog")
        contentController.add(self, name: "log")
        contentController.add(self, name: "msg")
        contentController.add(self, name: "err")
        web_view.uiDelegate = self
        web_view.navigationDelegate = self
        
    }
    
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body = message.body
        
        if message.name == "msg", let dict = message.body as? [String:Any] {
            if((dict["doc_ready"]) != nil){
                docdelegatex?.doc_ready()
            }
            else if((dict["keyup"]) != nil){
                docdelegatex?.doc_edited()
            }
            
            //            else if((dict["editor_ready"]) != nil){
            //                docdelegatex?.editor_ready()
            //            }
            
            //ALog.log_verbose("msg \(message.body)")
            
        }
        else if message.name == "log", let log = message.body as? String {
            ALog.log_verbose("WKLOG \(log)")
        }
        else if message.name == "err", let log = message.body as? String {
            ALog.log_error("WKERR \(log)")
        }
        else if let _ = message.body as? [String : AnyObject] {
            
            
        }else{
            ALog.log_verbose("JS PreviewWK: Non Dict Message: \(body)")
        }
        
    }
    
    
}

extension BANJSConnector {
    
    //MainActor is a new attribute introduced in Swift 5.5 as a global actor providing an executor which performs its tasks on the main thread.
    @MainActor
    public func run_editor_js(_ script: String) async throws -> Any? {
        //ALog.log_verbose("script \(script)")
        guard let wk = self.web_view else{
            ALog.log_warn("run_editor_js missing wk")
            throw BANError.no_webview
        }
        return try await withCheckedThrowingContinuation { continuation in
            wk.evaluateJavaScript(script) { a, e in
                if let e1 = e {
                    continuation.resume(throwing: e1)
                    return
                }
                continuation.resume(returning: a)
            }
        }
        //        return try await wk.evaluateJavaScript(script)
    }

    
}

//    @discardableResult func bild_js_editor(_ pref: TXTEditorPreference) async throws -> String? {
//        let data = try pref.to_json_data()
//        let str = "build_editor('\(data.base64EncodedString())')"
//        return try await run_editor_js(str) as? String
//    }
//
//
//    @discardableResult func update_js_editor(_ pref: TXTEditorPreference) async throws -> String? {
//        let data = try pref.to_json_data()
//        let str = "update_editor('\(data.base64EncodedString())')"
//        return try await run_editor_js(str) as? String
//    }
//
//    @discardableResult func set_js_content(_ content: String) async throws -> String? {
//        let str = "set_content('\(content.toBase64())')"
//        return try await run_editor_js(str) as? String
//    }
//
//    @discardableResult func set_js_lang(_ content: String) async throws -> String? {
//        let str = "change_lang('\(content)')"
//        return try await run_editor_js(str) as? String
//    }
//
//    @discardableResult func run_js_editor_action(_ action_id: String) async throws -> String? {
//        let str = "run_action('\(action_id)')"
//        return try await run_editor_js(str) as? String
//    }



//    func load_url_request(_ urlx: URLRequest?, completion: @escaping (Bool) -> ()) {
//        guard let wv = self.web_view else {
//            self.docdelegatex?.present_error(TXTError.no_webview)
//            return
//        }
//        guard let url = urlx?.url else {
//            self.docdelegatex?.present_error(TXTError.missing_url)
//            completion(false)
//            return
//        }
//        DispatchQueue.main.async {
//            if wv.isLoading {
//                wv.stopLoading()
//            }
//            let base_url = url.deletingLastPathComponent()
//            wv.loadFileURL(url, allowingReadAccessTo: base_url)
//            completion(true)
//        }
//    }
//        DispatchQueue.main.async {
//            return try await withCheckedThrowingContinuation { continuation in
//                let vca = VCAPhotoProcessor(settings)
//                photo_processing[settings.uniqueID] = vca
//                vca.completionHandler = { result in
//                    self.photo_processing[settings.uniqueID] = nil
//                    continuation.resume(with: result)
//                }
//                // The photo output holds a weak reference to the photo capture delegate
//                //and stores it in an array to maintain a strong reference.
//                output.capturePhoto(with: settings, delegate: vca)
//            }
//            wk.evaluateJavaScript(script,completionHandler: block)
//        }

//        let test_wk = selfweb_view // self.scene_delegatex?.scene_get_editor_controller(is_compact)?.editorWebView
//        guard let wk = test_wk else{
//            ALog.log_verbose("run_editor_js missing wk")
//            return
//        }
//        DispatchQueue.main.async {
//            wk.evaluateJavaScript(script,completionHandler: block)
//        }
//    }
