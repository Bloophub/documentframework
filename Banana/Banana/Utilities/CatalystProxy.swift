//
//  CatalystProxy.swift
//  HexCharlie
//
//  Created by Alec Isherwood on 18/05/2022.
//

import Foundation
import UIKit
import Dynamic

class CatalystProxy {

    @discardableResult static func intercept_window_close_button(_ window: UIWindow?) -> Bool{
        guard let windowx = window, let nsWindowx = windowx.nsWindow else {
            return false
        }
        let close_btn = nsWindowx.standardWindowButton(0)
        guard let _ = close_btn.asObject else{
            return false
        }
        close_btn.target = windowx
        return true
    }
    

    static func save_modal_panel(_ file_name: String, _ file_types: [String]) -> URL?{
        let save_panel = Dynamic.NSSavePanel()
        save_panel.allowedFileTypes = file_types //["html", "htm", "css", "js", "xml", "php"]
        if let doc_u = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            save_panel.directoryURL = doc_u
        }
        save_panel.nameFieldStringValue = file_name
        let response = save_panel.runModal()

        if response.asInt == 1 {
            return save_panel.URL.asObject as? URL
        }
        return nil

    }

}


extension UIWindow {

    var nsWindow: Dynamic? {
        var nsWindow = Dynamic.NSApplication.sharedApplication.delegate.hostWindowForUIWindow(self)
        if #available(macOS 11, *) {
            nsWindow = nsWindow.attachedWindow
        }
        return nsWindow //.asObject
    }
    //    var nsWindow: NSObject? {
    //        var nsWindow = Dynamic.NSApplication.sharedApplication.delegate.hostWindowForUIWindow(self)
    //        if #available(macOS 11, *) {
    //            nsWindow = nsWindow.attachedWindow
    //        }
    //        return nsWindow.asObject
    //    }
}
typealias ResponseBlock = @convention(block) (_ response: Int) -> Void
