//
//  TXTDocumentBrowserViewController.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/6/22.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

//The local file provider grants access to all the documents in the app’s Documents directory. Users can also access documents from another app’s Documents directory, if that app declares either the UISupportsDocumentBrowser key, or both the UIFileSharingEnabled and LSSupportsOpeningDocumentsInPlace keys in its Info.plist file. When the user opens a document from another app's Documents directory, they edit the document in place, and save the changes to the other app's Documents directory.
//The iCloud file provider creates a folder for your app in the user’s iCloud Drive. Users can access documents from this folder, or from anywhere in their iCloud Drive. The system automatically handles access to iCloud for you, so you don't need to enable your app’s iCloud capabilities.
//


//https://openradar.appspot.com/FB8894765


open class BANDocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    

    var my_next: UIResponder?
    override public var next: UIResponder? { get {
        if let my_nextx = my_next {
            return my_nextx
        }
        return super.next
    }}

    deinit {
        ALog.log_verbose("deinit TXTDocumentBrowserViewController")
    }
    
    public override init(forOpening contentTypes: [UTType]?){
        super.init(forOpening: contentTypes)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        if !BANPlatform.isCatalyst, let img = UIImage(systemName: "gear") {
            let gear_btn    = UIBarButtonItem(image: img, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(show_settings_btn))
            //self.navigationItem.rightBarButtonItem  = gear_btn
            self.additionalTrailingNavigationBarButtonItems = [gear_btn]
        }
    }
    
    @objc private func show_settings_btn(_ sender: Any?){
//        guard let del = docdelegatex  else { return }
//        doc_int_manager?.show_doc_int_pref()
        BANSceneManager.show_pref_menu(self)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        #if targetEnvironment(macCatalyst)
//        let nww = view.window?.nsWindow
////        if let v = nww?.isVisible.asBool,v  {
//            nww?.close()
////        }
//        #endif
    }
    
    open func get_template_url() -> URL?{
        XUrl.basic_document_url()
    }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    open func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = get_template_url()
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .copy)
        } else {
            importHandler(nil, .none)
        }
    }
    
    
    public func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the FileDocument View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        present_document_at(sourceURL)
    }
    
    public func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the FileDocument View Controller for the new newly created document
        present_document_at(destinationURL)
    }
    
    public func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
        if let errrox = error {
            ALog.log_error("error \(errrox)")
        }
    }
    
    open func build_doc_int_manager(_ url: URL) -> BANDocumentInterfaceManager{
        BANDocumentInterfaceManager(url)
    }
    
    public func get_doc_int_manager() -> BANDocumentInterfaceManager?{
        doc_int_manager
    }
    
    // MARK: FileDocument Presentation
    public var doc_int_manager: BANDocumentInterfaceManager?
    //https://stackoverflow.com/questions/67459304/how-to-avoid-strange-behavior-when-scene-based-document-mac-catalyst-app-reopens
    open func present_document_at(_ documentURL: URL) {
        ALog.log_verbose("presentDocument documentURL: \(documentURL)")
        
        if !documentURL.startAccessingSecurityScopedResource() {
            ALog.log_error("error accessing scoped resource")
        }
        
        if BANPlatform.isCatalyst {
            let scene = view.window?.windowScene
            BANSceneManager.open_doc_scene(scene,documentURL)
//            browser_delegatex?.browser_present_doc(documentURL)
            return
        }
        let doc_int_managerx        = build_doc_int_manager(documentURL)
        let nav                     = doc_int_managerx.build_gui()
        nav.modalPresentationStyle  = .fullScreen
        doc_int_manager             = doc_int_managerx
//        let nav                     = UINavigationController(rootViewController: doc_int_managerx.editor_vc)
        
        //swap responder
        let app_responder_next      = self.next         //saving original responder
        self.my_next                = doc_int_manager   //set scene_delegate as next of the doc_scene
        doc_int_managerx.my_next    = app_responder_next //set uiapp as next of doc_int_manager

        
        present(nav, animated: true)
    }
    
}

//extension TXTDocumentBrowserViewController: TXTDocumentInterfaceManagerGUIProtocol {
//    func get_uiviewcontroller() -> UIViewController? {
//        self
//    }
//}


