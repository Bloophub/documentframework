//
//  TXTDocumentInterfaceManager.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/6/22.
//

import Foundation
import UIKit


public protocol BANDocumentManagerProtocol: AnyObject, BANErrorProtocol {
    func get_js_connector() -> BANJSConnector
    func get_doc_url() -> URL
    func doc_will_close() async -> Bool
    func doc_will_save() async -> Bool
    func show_doc_int_pref()

    func doc_ready()
    func doc_edited()

//    func doc_root_uiviewcontroller() -> UIViewController?
}

open class BANDocumentInterfaceManager: UIResponder {
    open var file_url: URL! = nil
    open var doc: BANDocument! = nil
    open var js_connector = BANJSConnector()
    open var editor_vc = BANEditorUIViewController()

    var my_next: UIResponder?
    override public var next: UIResponder? { get {
        if let my_nextx = my_next {
            return my_nextx
        }
        return super.next
    }}
    
//    public required override init(){
//        super.init()
//    }

    public init(_ url: URL) {
        super.init()
        file_url = url
        doc      = build_doc(url)

    }
    
//    open class func build(_ url: URL) -> Self{
//        let di                          = Self()
//        di.file_url                     = url
//        di.doc                          = di.build_doc(url)
//        return di
//    }
    
    open func build_doc(_ url: URL) -> BANDocument{
        BANDocument(fileURL: url)
    }
    
    open func build_js_connector() -> BANJSConnector{
        let conn            = BANJSConnector()
        conn.docdelegatex   = self
        return conn
    }

    open func build_controllers() -> UIViewController{
        editor_vc               = BANEditorUIViewController()
        editor_vc.docdelegatex  = self
        return UINavigationController(rootViewController: editor_vc)
    }
    
    open func build_gui() -> UIViewController{
        js_connector    = build_js_connector()
        let nav         = build_controllers()
        return nav
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
    
//    public func doc_root_uiviewcontroller() -> UIViewController?{
//
//    }
    
    public func get_js_connector() -> BANJSConnector {
        js_connector
    }
    
    public func get_doc_url() -> URL{
        file_url
    }
    
    public func get_doc() -> BANDocument{
        doc
    }
    
    public func doc_will_save() async -> Bool{
        do{
            return try await editor_save_docx()
        }catch{
            present_error(error)
        }
        return false
    }
    
    public func doc_will_close() async -> Bool{
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
    public func editor_save_docx() async throws -> Bool{
        try await update_doc_contentx()
        let ret = await doc.save(to: get_doc_url(), for: .forOverwriting)
        ALog.log_verbose("savex \(ret)")
        return ret
    }
    
    @MainActor
    public func update_doc_contentx() async throws  {
        guard let content = try await js_connector.get_js_content() else { return }
        doc.update_content(content)
    }
    
    @MainActor
    public func doc_edited(){
        doc.updateChangeCount(.done)
    }

    public func doc_ready(){ //loaded js libs > load contant+ editor options
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
    public func show_doc_int_pref(){
        BANSceneManager.show_pref_menu(editor_vc)
    }

}


//MARK: - ACTION SAVE
extension BANDocumentInterfaceManager : BANMainMenuActionProtocol{
    public func file_menu_save_action(_ sender: Any?){
        Task{
            _ = await doc_will_save()
        }
    }
    
    public func file_menu_saveas_action(_ sender: Any?){
        #if targetEnvironment(macCatalyst)
        do{
            try scene_save_as_doc()
        }catch{
            present_error(error)
        }
        #endif
    }
    
    override public func validate(_ command: UICommand) {

    }
    
}

//MARK: - SAVEAS Catalyst
extension BANDocumentInterfaceManager {
    
    #if targetEnvironment(macCatalyst)
    public func scene_save_as_doc() throws {
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
    
    public func close_save_docx() async -> Bool { //clsoe on btn catalyst window
        await doc_will_close()
    }

    #endif

}

extension BANDocumentInterfaceManager : BANMainMenuEditorProtocol{
    open func editor_menu_run_editor_action(_ sender: Any?) {
//        run_monaco_editor_action(sender)
    }
}

//MARK: - ERROR
extension BANDocumentInterfaceManager {

    public func present_error(_ error: Error) {
        editor_vc.present_error(error)
    }
    
    public func present_error_text(_ text: String) {
        editor_vc.present_error_text(text)
    }
    
    public func present_alert(_ alert: UIAlertController) {
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
    
    
