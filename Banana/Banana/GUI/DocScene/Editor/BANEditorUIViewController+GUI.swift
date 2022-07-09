//
//  TXTMonacoEditorUIViewController+GUI.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/7/22.
//

import Foundation
import UIKit
import WebKit

//https://stackoverflow.com/questions/57048510/how-to-initialize-microsoft-monaco-editor-in-a-browser-using-simple-javascript-o
//https://microsoft.github.io/monaco-editor/playground.html#extending-language-services-configure-javascript-defaults
//https://microsoft.github.io/monaco-editor/api/modules/monaco.editor.html
//https://microsoft.github.io/monaco-editor/playground.html#creating-the-editor-hard-wrapping

//extension TXTMonacoEditorUIViewController: TXTMainMenuEditorProtocol {
//    func editor_menu_run_monaco_editor_action(_ sender: Any?) {
//
//    }
//}

extension BANEditorUIViewController {

    internal func build_ui(){
        
        view.backgroundColor = .systemBackground
//        self.title = "Text Editor"
//        view.backgroundColor = .red
    

        //LEFT
        if !BANPlatform.isCatalyst {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save_btn))
        }

        //RIGHT
        var rb              = [UIBarButtonItem]()
//        if !Platform.isCatalyst , let img = UIImage(systemName: "command") {
//            let cmd_btn     = UIBarButtonItem(image: img, landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
//            cmd_btn.menu    = editor_actions_menu()
////            lang_btn1.menu  = UIMenu(title: "", image: nil, identifier: nil, options: [.displayInline], children: editor_actions_menu())
//            rb.append(cmd_btn)
//        }
//
//        if let img          = UIImage(systemName: "chevron.left.forwardslash.chevron.right") {
//            let lang_btn1   = UIBarButtonItem(image: img, landscapeImagePhone: nil, style: .plain, target: nil, action: nil)
//            lang_btn = lang_btn1
//            lang_menu_update()
//            rb.append(lang_btn1)
//        }


        if !BANPlatform.isCatalyst {
            let close_btn   = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close_editor_btn))
            rb.append(close_btn)
        }

//        //KEY COMMANDS
//        if !Platform.isCatalyst {
//            add_editor_key_commands()
//        }

        navigationItem.rightBarButtonItems = rb.reversed()

        let store: WKWebsiteDataStore = WKWebsiteDataStore.default()
        let dataTypes: Set<String> = WKWebsiteDataStore.allWebsiteDataTypes()
        store.fetchDataRecords(ofTypes: dataTypes, completionHandler: { (records: [WKWebsiteDataRecord]) in
            store.removeData(ofTypes: dataTypes, for: records, completionHandler: {
          })
        })

        view.addSubview(wk_webview)
        wk_webview.util_fill_superview()

//        ALog.log_verbose("responderChain \(self.responderChain())")
//        ALog.log_verbose("responderChain \(self.navigationController?.responderChain())")

    }

//    private func editor_actions_menu() -> UIMenu{
//        return TXTAppMenu.editor_menu()
//    }
//
//    private func lang_menu_actions() -> [UIMenuElement]{
//        guard let del   = docdelegatex  else { return [] }
//        weak var me     = self
//        let actions: [UIMenuElement] = TXTLang.get_langs.compactMap { lan in
//            let act = UIAction(title: lan.rawValue.capitalized,image: nil,identifier: nil,discoverabilityTitle: nil, attributes: [],state: .off) { actw in
//                me?.changed_lang_act(lan)
//            }
//            act.state = del.get_current_lang() == lan ? .on : .off
//            return act
//        }
//        return actions
//    }
//
//    @MainActor
//    internal func lang_menu_update() {
//        lang_btn?.menu  = UIMenu(children: self.lang_menu_actions())
//    }
//
//    private func changed_lang_act(_ langx: TXTLang?){
//        guard let lang = langx else { return }
//        Task{
//            do{
//                try await change_lang(lang)
//            } catch {
//                self.present_error(error)
//            }
//        }
//    }
    
    @objc private func show_settings_btn(_ sender: Any?){
        guard let del = docdelegatex  else { return }
        del.show_doc_int_pref()
    }
    
    public func release_editor(){
        guard let del   = docdelegatex  else { return }
        let js_conn     = del.get_js_connector()
        js_conn.unregister_connector()
        wk_webview.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func close_editor_btn(_ sender: Any?){
        guard let del   = docdelegatex  else { return }
        Task{
            guard await del.doc_will_close() else { return }
            if !BANPlatform.isCatalyst {
                dismiss(animated: true)
            }
        }
    }

    @objc private func save_btn(_ sender: Any?){
        guard let del = docdelegatex  else { return }
        Task{ //Task.detached{
            await del.doc_will_save()
        }
    }

}
