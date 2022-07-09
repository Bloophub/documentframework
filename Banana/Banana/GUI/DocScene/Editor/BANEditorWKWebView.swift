//
//  TXTMonacoEditorWKWebView.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/7/22.
//

import Foundation
import UIKit
import WebKit

class BANEditorWKWebView: WKWebView {
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configure_wk_ui()
    }
    
    deinit{
        ALog.log_verbose("deinit TXTMonacoEditorWKWebView")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure_wk_ui(){
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
    
    override var canBecomeFirstResponder: Bool{
        return true
    }

}

