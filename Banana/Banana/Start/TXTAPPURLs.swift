//
//  TXTPaths.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/6/22.
//

import Foundation

public class TXTAPPURLs{
    public static var base_url: URL?
    public static var edit_url: URL?

    public class func get_editor_url() -> URL?{
        edit_url?.appendingPathComponent("editor.html")
    }
    
    public class func basic_document_url() -> URL?{
        let newDocumentURL: URL? = Bundle.main.url(forResource: "new_page", withExtension: "html")
        return newDocumentURL
    }

    
    public class func create_urls() throws {
        guard let group_url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: app_group) else {
            return
        }

        let group_app_support = group_url.appendingPathComponent("Library")
            .appendingPathComponent("Application Support")
            .appendingPathComponent(APP_FOLDER_NAME)
        
        try FileManager.default.createDirectory(at: group_app_support, withIntermediateDirectories: true, attributes: nil)
        base_url = group_app_support
        
//        sessions_url = group_app_support.appendingPathComponent("Sessions")
//        try file_manager.createDirectory(at: sessions_url!, withIntermediateDirectories: true, attributes: nil)
//
//        services_url = group_app_support.appendingPathComponent("Services")
//        try file_manager.createDirectory(at: services_url!, withIntermediateDirectories: true, attributes: nil)
//
//        editorPref_url = group_app_support.appendingPathComponent("Editor")
//        try file_manager.createDirectory(at: editorPref_url!, withIntermediateDirectories: true, attributes: nil)

        let edit_urlx = group_app_support.appendingPathComponent("Editor")
        if FileManager.default.fileExists(atPath: edit_urlx.path) {
            try FileManager.default.removeItem(at: edit_urlx)
        }
        if let u = Bundle.main.url(forResource: "Editor", withExtension: nil) {
            try FileManager.default.copyItem(at: u, to: edit_urlx)
        }
        edit_url = edit_urlx
        
//        generate_default_files()

    }

}
