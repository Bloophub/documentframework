//
//  BANWKWebViewUIViewController.swift
//  Banana
//
//  Created by Giovanni Simonicca on 7/10/22.
//

import Foundation
import WebKit
import UIKit

open class BANWKWebViewUIViewController: UIViewController {
    
    public var file_url: URL?
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
        view.backgroundColor = .systemBackground
        if !BANPlatform.isCatalyst {
            let close_btn   = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close_wk_btn))
            self.navigationItem.rightBarButtonItem = close_btn
        }
        view.addSubview(wk_webview)
        wk_webview.util_fill_superview()
        
        if let u = file_url {
            wk_webview.loadFileURL(u, allowingReadAccessTo: u.deletingLastPathComponent())
        }
    }
    
    @objc func close_wk_btn(_ sender: Any?){
        dismiss(animated: true)
    }
}
