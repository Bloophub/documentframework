
//
//  FileDocument.swift
//  HexV3
//
//  Created by Alec Isherwood on 05/07/2021.
//

import UIKit

//https://www.techotopia.com/index.php/Managing_Files_using_the_iOS_8_UIDocument_Class
open class BANDocument: UIDocument {
    
    private var contentx = ""
    public func update_content(_ html: String){
        contentx = html
        self.updateChangeCount(.done)
    }
    
    public func get_content() -> String{
        return contentx
    }
    
    override public func autosave(completionHandler: ((Bool) -> Void)? = nil) {
        super.autosave(completionHandler: completionHandler)
    }
    
    //WRITING
    override public func contents(forType typeName: String) throws -> Any { //data package
        // Encode your document with an instance of NSData or NSFileWrapper
        let data = contentx.data(using: .utf8) as Any
        return data
    }
    
    //READING
    override public func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        //ALog.log_verbose("load")
        guard let data = contents as? Data else { return }
        contentx = String(data: data, encoding: .utf8) ?? ""
    }
    
    
//    override func writeContents(_ contents: Any, andAttributes additionalFileAttributes: [AnyHashable : Any]? = nil,
//                                safelyTo url: URL,
//                                for saveOperation: UIDocument.SaveOperation) throws {
//        ALog.log_verbose("writeContents")
//        do{
//            try super.writeContents(contents, andAttributes: additionalFileAttributes, safelyTo: url, for: saveOperation)
//        }catch {
//            ALog.log_error("writeContents \(error)")
//            throw error
//        }
//    }
    
    deinit {
        ALog.log_verbose("deinit BANDocument")
    }
    
//    override func updateUserActivityState(_ userActivity: NSUserActivity) {
//        
//    }
//    
//    override func restoreUserActivityState(_ userActivity: NSUserActivity) {
//        
//    }
}

