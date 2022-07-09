//
//  TXTDocumentInterfaceManager.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/6/22.
//

import Foundation
import UIKit


protocol BANDocumentManagerProtocol: AnyObject, BANErrorProtocol {
    func get_js_connector() -> BANJSConnector
    func get_doc_url() -> URL
    func doc_will_close() async -> Bool
    func doc_will_save() async -> Bool
    func show_doc_int_pref()

    func doc_ready()
    func doc_edited()

//    func run_editor_command_action(_ command: UICommand);
//    func run_editor_actionid(_ actid: String)
}

class BANDocumentInterfaceManager: UIResponder {
//    var current_lang: TXTLang = .js
    var file_url: URL! = nil
    var doc: BANDocument! = nil
    let js_connector = BANJSConnector()
    let editor_vc = BANEditorUIViewController()

    var my_next: UIResponder?
    override var next: UIResponder? { get {
        if let my_nextx = my_next {
            return my_nextx
        }
        return super.next
    }}

    class func build(_ url: URL) -> BANDocumentInterfaceManager{
        let di                          = BANDocumentInterfaceManager()
        di.file_url                     = url
        di.doc                          = BANDocument(fileURL: url)
        di.js_connector.docdelegatex    = di
        di.editor_vc.docdelegatex       = di
        return di
    }
    
    @MainActor
    func relase_all(){
        editor_vc.release_editor()
    }
    
    deinit{
        ALog.log_verbose("deinit TXTDocumentInterfaceManager")
    }
}

//MARK: - DOC
extension BANDocumentInterfaceManager {
    func open_docx() async -> Bool{
        let st = doc.documentState
        if st == .closed { return await doc.open() }
        return true
//        doc.documentState == .closed ? await doc.open() : true
    }
    
    func close_docx() async -> Bool {
        let st = doc.documentState
        if st != .closed { return await doc.close() }
        return false
    }
}

//MARK: - DOC DEL
extension BANDocumentInterfaceManager : BANDocumentManagerProtocol{
    
    func get_js_connector() -> BANJSConnector {
        js_connector
    }
    
    func get_doc_url() -> URL{
        file_url
    }
    
    func get_doc() -> BANDocument{
        doc
    }
    
    func doc_will_save() async -> Bool{
        do{
            return try await editor_save_docx()
        }catch{
            present_error(error)
        }
        return false
    }
    
    func doc_will_close() async -> Bool{
        do{
            guard try await editor_save_docx() else { return false }
            let close = await close_docx()
            ALog.log_verbose("closed \(close)")
            relase_all()
            return close
        }catch{
            present_error(error)
        }
        return false
    }

    
    //update content+save
    func editor_save_docx() async throws -> Bool{
        try await update_doc_contentx()
        return await doc.save(to: get_doc_url(), for: .forOverwriting)
    }
    
    @MainActor
    func update_doc_contentx() async throws  {
        guard let content = try await js_connector.get_js_content() else { return }
        doc.update_content(content)
    }
    
    @MainActor
    func doc_edited(){
        doc.updateChangeCount(.done)
    }

    func doc_ready(){ //loaded js libs > load contant+ editor options
        Task {
            ALog.log_verbose("editor_ready")
            do {
                if await open_docx() == false {
                    throw BANError.error_doc
                }
                try await editor_vc.editor_loaded_html(doc.get_content(), get_doc_url())
            }catch {
                present_error(error)
            }
        }
    }
    
    @MainActor
    func show_doc_int_pref(){
        BANSceneManager.show_pref_menu(editor_vc)
    }

//    func run_editor_command_action(_ command: UICommand){
//        
//    }
//    
//    func run_editor_actionid(_ actid: String){
//        
//    }
}


//MARK: - ACTION
extension BANDocumentInterfaceManager : TXTMainMenuActionProtocol{
    func file_menu_save_action(_ sender: Any?){
        Task{
            _ = await doc_will_save()
        }
    }
    
    func file_menu_saveas_action(_ sender: Any?){
        #if targetEnvironment(macCatalyst)
        do{
            try scene_save_as_doc()
        }catch{
            present_error(error)
        }
        #endif
    }
    
    override func validate(_ command: UICommand) {

    }
    
}

//MARK: - SAVEAS Catalyst
extension BANDocumentInterfaceManager {
    
    #if targetEnvironment(macCatalyst)
    func scene_save_as_doc() throws {
        let fileManager = FileManager.default
        let dummy_doc_url = doc.fileURL
        guard dummy_doc_url.startAccessingSecurityScopedResource() else {
            throw BANError.error_doc
        }
        let file_name = "";
        guard let new_doc_url = BANCatalystProxy.save_modal_panel(file_name,[dummy_doc_url.pathExtension]) else {
            throw BANError.error_doc
        }
        guard new_doc_url.startAccessingSecurityScopedResource() else {
            throw BANError.error_doc
        }
        if fileManager.fileExists(atPath: new_doc_url.path){
            try fileManager.removeItem(at: new_doc_url)
        }
        try fileManager.copyItem(at: dummy_doc_url, to: new_doc_url)
        //if exist destroy and recreate
        if let doc_scene = BANSceneManager.doc_scene(new_doc_url) {
            BANSceneManager.close_scene(doc_scene.session)
        }
        BANSceneManager.open_doc_scene(nil, new_doc_url)
    }
    
    func close_save_docx() async -> Bool { //clsoe on btn catalyst window
        await doc_will_close()
    }

    #endif

}

extension BANDocumentInterfaceManager : TXTMainMenuEditorProtocol{
    func editor_menu_run_editor_action(_ sender: Any?) {
//        run_monaco_editor_action(sender)
    }
    
//    private func run_monaco_editor_action(_ sender: Any?){
//        guard let command = sender as? UICommand else { return }
//        run_monaco_editor_command_action(command)
//    }
//
//    func run_monaco_editor_command_action(_ command: UICommand){
//        guard let dict = command.propertyList as? [String: String], let actid = dict["act"] else { return }
//        run_monaco_editor_actionid(actid)
//    }
//
//    func run_monaco_editor_actionid(_ actid: String){
//        Task{
//            do{
//                try await js_connector.run_js_editor_action(actid)
//            }catch{
//                present_error(error)
//            }
//        }
//    }

}

//MARK: - ERROR
extension BANDocumentInterfaceManager {

    func present_error(_ error: Error) {
        editor_vc.present_error(error)
    }
    
    func present_error_text(_ text: String) {
        editor_vc.present_error_text(text)
    }
    
    func present_alert(_ alert: UIAlertController) {
        editor_vc.present_alert(alert)
    }
}
//        self.get_editor_js_connector(scene_is_compact()).editor_has_changes { isClean, error in
//
//            guard
//                isClean == false,
//                error == nil,
//                let fb_id = self.get_current_editor_info().file_bucket_id
//            else {
//                self.scene_get_main_controller()?.close_session(true, block: { result in
//                    block(result)
//                })
//                return
//            }
//
//            let file_bucket = self.file_server_delegatex?.get_file_bucket(fb_id)
//
//            let alert = UIAlertController(title: file_bucket?.name,
//                                          message: "Do you want to upload the changes?",
//                                          preferredStyle: .alert)
//
//            let cancel_a = UIAlertAction(title: "Cancel", style: .cancel) { act in
//                block(false)
//            }
//            alert.addAction(cancel_a)
//
//            let discard_a = UIAlertAction(title: "Discard", style: .destructive) { act in
//                self.scene_get_main_controller()?.close_session(true, block: { result in
//                    block(result)
//                })
//            }
//            alert.addAction(discard_a)
//
//            let save_a = UIAlertAction(title: "Upload Changes", style: .default) { act in
//                self.scene_get_main_controller()?.save_file_internal({ error in
//                    guard error == nil else {
//                        block(false)
//                        return
//                    }
//                    self.scene_get_main_controller()?.close_session(true, block: { result in
//                        block(result)
//                    })
//                })
//            }
//            alert.addAction(save_a)
//            self.main_controller.present(alert, animated: false)
//
//        }

//
//    func scene_save_doc() async throws  {
//        if doc.documentState == .closed {
//            throw TXTError.error_doc
//        }
//
//        get_ace_content { content, error in
//            guard error == nil else{
//                completionHandler(false)
//                return nil
//            }
//            guard let contentString = content else {
//                completionHandler(false)
//                return nil
//            }
//            doc.assign_html(contentString)
//            let docfileURL = doc.fileURL
//            if docfileURL.startAccessingSecurityScopedResource() {
//                doc.save(to: docfileURL, for: .forOverwriting) { succes in
//                    docfileURL.stopAccessingSecurityScopedResource()
//                    completionHandler(succes)
//                }
//            }
//            completionHandler(true)
//            return nil
//        }
//
//    }
    
//    func scene_close_and_save_doc(completionHandler: @escaping ((Bool) -> Void)){
//        self.scene_save_doc{ succes_close in
//            doc.close { success_save in
//                if(success_save == false) {
//                    let filename: String = doc.fileURL.lastPathComponent.description
//                    ALog.log_error("Error scene_save_doc filename: \(filename)")
//                    HEXPresenterUtility.xalert(title: "Oops!", message: "We're sorry. We had problems saving: \(filename)")
//                }
//                completionHandler(success_save)
//            }
//        }
//    }
    
    
