//
//  MEMMainMenuController.swift
//  HEXv2
//
//  Created by Alec Isherwood on 07/07/2021.
//

import Foundation
import UIKit


@objc protocol TXTMainMenuGeneralProtocol: AnyObject {
    @objc optional func menu_pref_action(_ sender: Any?)
    @objc optional func file_menu_new_action(_ sender: Any?)
    @objc optional func file_menu_open_action(_ sender: Any?)
}

/// Editor Protocols
@objc protocol TXTMainMenuActionProtocol: AnyObject {
    @objc optional func file_menu_save_action(_ sender: Any?)
    @objc optional func file_menu_saveas_action(_ sender: Any?)
}
//
//(
//    "editor.action.toggleHighContrast",
//    "editor.action.setSelectionAnchor",
//    "editor.action.moveCarretLeftAction",
//    "editor.action.moveCarretRightAction",
//    "editor.action.transposeLetters",
//    "editor.action.clipboardCopyWithSyntaxHighlightingAction",
//    "editor.action.commentLine",
//    "editor.action.addCommentLine",
//    "editor.action.removeCommentLine",
//    "editor.action.blockComment",
//    "editor.action.showContextMenu",
//    cursorUndo,
//    cursorRedo,
//    "editor.action.fontZoomIn",
//    "editor.action.fontZoomOut",
//    "editor.action.fontZoomReset",
//    "editor.action.indentationToSpaces",
//    "editor.action.indentationToTabs",
//    "editor.action.indentUsingTabs",
//    "editor.action.indentUsingSpaces",
//    "editor.action.detectIndentation",
//    "editor.action.reindentlines",
//    "editor.action.reindentselectedlines",
//    expandLineSelection,
//    "editor.action.copyLinesUpAction",
//    "editor.action.copyLinesDownAction",
//    "editor.action.duplicateSelection",
//    "editor.action.moveLinesUpAction",
//    "editor.action.moveLinesDownAction",
//    "editor.action.sortLinesAscending",
//    "editor.action.sortLinesDescending",
//    "editor.action.removeDuplicateLines",
//    "editor.action.trimTrailingWhitespace",
//    "editor.action.deleteLines",
//    "editor.action.indentLines",
//    "editor.action.outdentLines",
//    "editor.action.insertLineBefore",
//    "editor.action.insertLineAfter",
//    deleteAllLeft,
//    deleteAllRight,
//    "editor.action.joinLines",
//    "editor.action.transpose",
//    "editor.action.transformToUppercase",
//    "editor.action.transformToLowercase",
//    "editor.action.transformToSnakecase",
//    "editor.action.transformToTitlecase",
//    "editor.action.smartSelect.expand",
//    "editor.action.smartSelect.shrink",
//    "editor.action.toggleTabFocusMode",
//    "editor.action.forceRetokenize",
//    deleteInsideWord,
//    "editor.action.quickCommand",
//    "editor.action.gotoLine",
//    "editor.action.inPlaceReplace.up",
//    "editor.action.inPlaceReplace.down",
//    "editor.action.showAccessibilityHelp",
//    "editor.action.inspectTokens",
//    "editor.action.selectToBracket",
//    "editor.action.jumpToBracket",
//    "editor.action.openLink",
//    "editor.action.wordHighlight.trigger",
//    "actions.find",
//    "editor.action.startFindReplaceAction",
//    "editor.actions.findWithArgs",
//    "actions.findWithSelection",
//    "editor.action.nextMatchFindAction",
//    "editor.action.previousMatchFindAction",
//    "editor.action.nextSelectionMatchFindAction",
//    "editor.action.previousSelectionMatchFindAction",
//    "editor.action.insertCursorAbove",
//    "editor.action.insertCursorBelow",
//    "editor.action.insertCursorAtEndOfEachLineSelected",
//    "editor.action.addSelectionToNextFindMatch",
//    "editor.action.addSelectionToPreviousFindMatch",
//    "editor.action.moveSelectionToNextFindMatch",
//    "editor.action.moveSelectionToPreviousFindMatch",
//    "editor.action.selectHighlights",
//    "editor.action.addCursorsToBottom",
//    "editor.action.addCursorsToTop",
//    "editor.unfold",
//    "editor.unfoldRecursively",
//    "editor.fold",
//    "editor.foldRecursively",
//    "editor.foldAll",
//    "editor.unfoldAll",
//    "editor.foldAllBlockComments",
//    "editor.foldAllMarkerRegions",
//    "editor.unfoldAllMarkerRegions",
//    "editor.foldAllExcept",
//    "editor.unfoldAllExcept",
//    "editor.toggleFold",
//    "editor.gotoParentFold",
//    "editor.gotoPreviousFold",
//    "editor.gotoNextFold",
//    "editor.foldLevel1",
//    "editor.foldLevel2",
//    "editor.foldLevel3",
//    "editor.foldLevel4",
//    "editor.foldLevel5",
//    "editor.foldLevel6",
//    "editor.foldLevel7",
//    "editor.action.marker.next",
//    "editor.action.marker.prev",
//    "editor.action.marker.nextInFiles",
//    "editor.action.marker.prevInFiles",
//    "editor.action.showHover",
//    "editor.action.showDefinitionPreviewHover",
//    "editor.action.unicodeHighlight.disableHighlightingOfAmbiguousCharacters",
//    "editor.action.unicodeHighlight.disableHighlightingOfInvisibleCharacters",
//    "editor.action.unicodeHighlight.disableHighlightingOfNonBasicAsciiCharacters",
//    "editor.action.unicodeHighlight.showExcludeOptions",
//    "editor.action.triggerSuggest",
//    "editor.action.resetSuggestSize",
//    "editor.action.inlineSuggest.trigger"
//)

@objc protocol TXTMainMenuEditorProtocol: AnyObject {
//    func editor_menu_format_doc(_ sender: Any?)
//    func editor_menu_format_selection(_ sender: Any?)
    func editor_menu_run_editor_action(_ sender: Any?)
}

//
///// WebView Protocols
//@objc protocol HEXMainMenuWebViewActionProtocol {
//    func preview_menu_browser_action(_ sender: Any?)
//    func preview_menu_hide_action(_ sender: Any?)
//}



/// Browser Protocols
//@objc protocol HEXMainMenuBrowserActionProtocol {
//    func connection_menu_ftp_action(_ sender: Any?)
//}

class TXTAppMenu : UIResponder{
    
    init(with builder: UIMenuBuilder) {
        
        /// Removal
        builder.remove(menu: UIMenu.Identifier.services)
        builder.remove(menu: UIMenu.Identifier.format)
        builder.remove(menu: UIMenu.Identifier.font)
//        builder.remove(menu: UIMenu.Identifier.edit)
        builder.remove(menu: UIMenu.Identifier.newScene)
        //builder.
        

        /// Preference Menu
        let pref_menu = TXTAppMenu.pref_menu()
        builder.insertSibling(pref_menu, afterMenu: .about)

        if BANPlatform.isCatalyst{
            /// File Menu
            let file_sec_1_menu = TXTAppMenu.crud_menu()
            builder.insertChild(file_sec_1_menu, atStartOfMenu: .file)

            let file_sec_2_menu = TXTAppMenu.separator_menu()
            builder.insertSibling(file_sec_2_menu, afterMenu: file_sec_1_menu.identifier)

            let file_sec_3_menu = TXTAppMenu.new_doc_menu()
            builder.insertSibling(file_sec_3_menu, afterMenu: file_sec_2_menu.identifier)
        }
//
//        /// Insert Menu
//        let insert_menu = HEXMainMenuController.hex_insert_menu()
//        builder.insertSibling(insert_menu, afterMenu: .edit)
//
//        let insert_menu_sec_1 = HEXMainMenuController.hex_insert_sec_1_menu()
//        builder.insertChild(insert_menu_sec_1, atStartOfMenu: insert_menu.identifier)
//
//        let insert_menu_sec_1_meta = HEXMainMenuController.hex_insert_sec_1_meta_menu()
//        builder.insertSibling(insert_menu_sec_1_meta, afterMenu: insert_menu_sec_1.identifier)
//
//        let insert_menu_sec_2_meta = HEXMainMenuController.hex_insert_sec_2_meta_menu()
//        builder.insertChild(insert_menu_sec_2_meta, atEndOfMenu: insert_menu.identifier)
//
//
//
//        /// Code Menu
//        let code_menu = TXTAppMenu.editor_menu()
//        builder.insertSibling(code_menu, afterMenu: .edit)

        
//        let cmd = UIKeyCommand(title: "TestCmd", action: #selector(TXTMainMenuGeneralProtocol.menu_pref_action(_:)), input: "x", discoverabilityTitle: "Test command")
//        let menu = UIMenu(title: NSLocalizedString("Test group", comment: "hotkey group name"),
//                      image: nil, identifier: UIMenu.Identifier(rawValue: "myapp.menu.ios.test"),
//                      children: [cmd])
//       builder.insertSibling(menu, afterMenu: .view)

//        let code_menu_sec_1 = TXTMainMenuController.hex_code_sec_1_menu()
//        builder.insertChild(code_menu_sec_1, atStartOfMenu: code_menu.identifier)
//
//        let code_menu_sec_2 = TXTMainMenuController.hex_code_sec_2_menu()
//        builder.insertSibling(code_menu_sec_2, afterMenu: code_menu_sec_1.identifier)
//
//
//
//        /// Preview Menu
//        let preview_menu = HEXMainMenuController.hex_preview_menu()
//        builder.insertSibling(preview_menu, afterMenu: insert_menu.identifier)
//
//        let preview_menu_sec_1 = HEXMainMenuController.hex_preview_sec_1_menu()
//        builder.insertChild(preview_menu_sec_1, atStartOfMenu: preview_menu.identifier)
//
//
////        /// Connection Menu
////        let connection_sec_1_menu = HEXMainMenuController.hex_connection_sec_1_menu()
////        builder.insertSibling(connection_sec_1_menu, afterMenu: preview_menu.identifier)
        
    }

    class func pref_menu() -> UIMenu {
        var menu_children:[UIMenuElement] = []
        let prefCommand =
            UIKeyCommand(title: NSLocalizedString("Preferences", comment: ""),
                         image: nil,
                         action: #selector(TXTMainMenuGeneralProtocol.menu_pref_action(_:)),
                         input: ",",
                         modifierFlags: .command,
                         propertyList: ["open", "true"])
        menu_children.append(prefCommand)
        let Menu =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("pref_item"),
                   options: .displayInline,
                   children: menu_children)
        return Menu
    }
    
    
    class func crud_menu() -> UIMenu {
        var menu_children:[UIMenuElement] = []
        
        let openCommand =
            UIKeyCommand(title: NSLocalizedString("Open", comment: ""),
                         image: nil,
                         action: #selector(TXTMainMenuGeneralProtocol.file_menu_open_action(_:)),
                         input: "O",
                         modifierFlags: .command,
                         propertyList: ["open", "true"])
        menu_children.append(openCommand)
        let saveCommand =
            UIKeyCommand(title: NSLocalizedString("Save", comment: ""),
                         image: nil,
                         action: #selector(TXTMainMenuActionProtocol.file_menu_save_action(_:)),
                         input: "S",
                         modifierFlags: .command,
                         propertyList: nil)
        menu_children.append(saveCommand)
        let saveAsCommand =
            UIKeyCommand(title: NSLocalizedString("Save As", comment: ""),
                         image: nil,
                         action: #selector(TXTMainMenuActionProtocol.file_menu_saveas_action(_:)),
                         input: "S",
                         modifierFlags: [.command, .shift],
                         propertyList: nil)
        menu_children.append(saveAsCommand)
        let Menu =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("file_sec1_items"),
                   options: .displayInline,
                   children: menu_children)
        return Menu
    }

    class func separator_menu() -> UIMenu { //separator
        UIMenu(title: "",image: nil,identifier: nil,options: .displayInline,children: [])
    }
    
    class func new_doc_menu() -> UIMenu {
        var menu_children:[UIMenuElement] = []
        let exportCommand =
            UIKeyCommand(title: NSLocalizedString("New Document", comment: ""),
                         image: nil,
                         action: #selector(TXTMainMenuGeneralProtocol.file_menu_new_action(_:)),
                         input: "N",
                         modifierFlags: .command,
                         propertyList: nil)
        menu_children.append(exportCommand)
        let Menu =
            UIMenu(title: "",
                   image: nil,
                   identifier: UIMenu.Identifier("file_sec3_items"),
                   options: .displayInline,
                   children: menu_children)
        return Menu
    }
    
    class func editor_menu() -> UIMenu {
        return UIMenu(title: "Editor", image: nil, identifier: UIMenu.Identifier("editor_menu"), options: [], children: editor_key_command_menu_actions())
    }
    
    
    private class func editor_key_command_menu_actions() -> [UIMenuElement] {
        
//        let sel: Selector = #selector(TXTMainMenuGeneralProtocol.menu_pref_action(_:))
        let sel: Selector = #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:))
        //TXTMainMenuGeneralProtocol.menu_pref_action(_:)
        
        var childrens = [UIMenuElement]()
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Format Doc", comment: ""),image: nil,
                                      action: sel,
                                      input: "F",modifierFlags: [.shift, .alternate],propertyList: ["act": "editor.action.formatDocument"])
                childrensx.append(kc)
            }
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Format Selection", comment: ""),image: nil,
                                      action: sel,
                                      input: "KF",modifierFlags: [.command],propertyList: ["act": "editor.action.formatSelection"])
                childrensx.append(kc)
            }

            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)
        }
        
        //ZOOM
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Font Zoom In", comment: ""),image: nil,
                                      action: sel,
                                      input: "+", modifierFlags: [.command],propertyList: ["act": "editor.action.fontZoomIn"])
                childrensx.append(kc)
            }
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Font Zoom Out", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      input: "-",modifierFlags: [.command], propertyList: ["act": "editor.action.fontZoomOut"])
                childrensx.append(kc)
            }
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Font Zoom Reset", comment: ""),image: nil,
                                      action: sel,
                                      input: "0",modifierFlags: [.command],propertyList: ["act": "editor.action.fontZoomReset"])
                childrensx.append(kc)
            }

            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)
        }
        
        //COMMAND PALETTE
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Command Palette", comment: ""),image: nil,
                                      action: sel,
                                      input: UIKeyCommand.f1 ,modifierFlags: [],propertyList: ["act": "editor.action.quickCommand"])
                childrensx.append(kc)
            }
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Rename", comment: ""),image: nil,
                                      action: sel,
                                      input: UIKeyCommand.f2 ,modifierFlags: [],propertyList: ["act": "editor.action.onTypeRename"])
                childrensx.append(kc)
            }
            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)
        }
        
        //COMMAND Fold
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Fold", comment: ""),image: nil,
                                      action: sel,
                                      input: "[" ,modifierFlags: [.command,.alternate],propertyList: ["act": "editor.fold"])
                childrensx.append(kc)
            }
            if true {
                let kc = UIKeyCommand(title: NSLocalizedString("Unfold", comment: ""),image: nil,
                                      action: sel,
                                      input: "]" ,modifierFlags: [.command,.alternate],propertyList: ["act": "editor.unfold"])
                childrensx.append(kc)
            }
            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)
        }
        
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UICommand(title: NSLocalizedString("Uppercase", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.transformToUppercase"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Lowercase", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.transformToLowercase"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Snakecase", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.transformToSnakecase"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Titlecase", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.transformToTitlecase"])
                childrensx.append(kc)
            }
            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)
        }
        
        if true {
            var childrensx = [UIMenuElement]()
            if true {
                let kc = UICommand(title: NSLocalizedString("Duplicate Selection", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.duplicateSelection"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Copy Lines Up", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.copyLinesUpAction"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Copy Lines Down", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.copyLinesDownAction"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Move Lines Up", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.moveLinesUpAction"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Move Lines Down", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.moveLinesDownAction"])
                childrens.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Sort Lines Ascending", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.sortLinesAscending"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Sort Lines Descending", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.sortLinesDescending"])
                childrens.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Remove Duplicate Lines", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.removeDuplicateLines"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Trim Trailing Whitespace", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.trimTrailingWhitespace"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Delete Lines", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.deleteLines"])
                childrens.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Indent Lines", comment: ""),image: nil,
                                      action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_editor_action(_:)),
                                      propertyList: ["act": "editor.action.indentLines"])
                childrensx.append(kc)
            }
            if true {
                let kc = UICommand(title: NSLocalizedString("Outdent Lines", comment: ""),image: nil,
                                      action: sel,
                                      propertyList: ["act": "editor.action.outdentLines"])
                childrensx.append(kc)
            }
            let menu = UIMenu(title: "",image: nil,identifier: nil,options: .displayInline, children: childrensx)
            childrens.append(menu)

        }

//        //    "editor.action.copyLinesUpAction",
//        //    "editor.action.copyLinesDownAction",
//        //    "editor.action.duplicateSelection",
//        //    "editor.action.moveLinesUpAction",
//        //    "editor.action.moveLinesDownAction",
//        //    "editor.action.sortLinesAscending",
//        //    "editor.action.sortLinesDescending",
//        //    "editor.action.removeDuplicateLines",
//        //    "editor.action.trimTrailingWhitespace",
//        //    "editor.action.deleteLines",
//        //    "editor.action.indentLines",
//        //    "editor.action.outdentLines",
//
//
        return childrens
    }
    
//    class func separator_command() -> UIKeyCommand{
//        let kc = UIKeyCommand(title: NSLocalizedString("Rename", comment: ""),image: nil,
//                              action: #selector(TXTMainMenuEditorProtocol.editor_menu_run_monaco_editor_action(_:)),
//                              input: UIKeyCommand.f2 ,modifierFlags: [],propertyList: ["act": "editor.action.onTypeRename"])
//        childrens.append(kc)
//
//    }
}

//extension TXTAppMenu {
//    
//    class func uimenuelement_to_action(_ el: UIMenuElement, _ handler: @escaping (UICommand,UIAction) -> Void) -> UIMenuElement?{
//        if let command = el as? UICommand {
//            return keycommand_to_action(command, handler)
//        }
//        else if let menu = el as? UIMenu {
//            let childs: [UIMenuElement] = menu.children.compactMap { el in
//                uimenuelement_to_action(el,handler)
//            }
//            let me = UIMenu(title: menu.title, image: menu.image, identifier: menu.identifier, options: menu.options, children: childs)
//            return me
//        }
//        return nil
//    }
//    
//    class func keycommand_to_action(_ command: UICommand, _ handler: @escaping (UICommand,UIAction) -> Void) -> UIMenuElement?{
//        UIAction(title: command.title, subtitle: command.subtitle, image: command.image,
//                 identifier: nil, discoverabilityTitle: command.discoverabilityTitle,
//                 attributes: command.attributes,state: command.state) { act in
//            handler(command,act)
//        }
//    }
//
//    class func plain_keycommands(_ elements: [UIMenuElement]) -> [UIKeyCommand]{
//        var kcs = [UIKeyCommand]()
//        elements.forEach { el in
//            if let kc = el as? UIKeyCommand {
//                kcs.append(kc)
//            }
//            if let menu = el as? UIMenu {
//                kcs.append(contentsOf: plain_keycommands(menu.children))
//            }
//        }
//        return kcs
//    }
//}

//MARK: - AppDelegate
extension BANAppDelegate: TXTMainMenuGeneralProtocol {
    
    override func validate(_ command: UICommand) {
        if command.action == #selector(file_menu_open_action(_:)) {
            command.attributes = []
            if BANSceneManager.file_browser_scene() != nil {
                command.attributes = .disabled
            }
        }
    }
    
    @objc func file_menu_open_action(_ sender: Any?) {
        #if targetEnvironment(macCatalyst)
        BANSceneManager.open_file_browser_scene { err in
            BANSceneManager.open_alert_error_scene(APPNAME, err)
        }
        #endif
    }
    
    @objc func file_menu_new_action(_ sender: Any?) {
        #if targetEnvironment(macCatalyst)
        do{
            try BANSceneManager.new_doc()
        }catch {
            ALog.log_error("file_menu_new_action \(error)")
            BANSceneManager.open_alert_error_scene(APPNAME, error)
        }
        #endif
    }
    
    @objc func menu_pref_action(_ sender: Any?) {
        BANSceneManager.show_pref_menu(nil)
    }
    
}

/*
 
 [
   "actions.find",
   "actions.findWithSelection",
   "cursorRedo",
   "cursorUndo",
   "deleteAllLeft",
   "deleteAllRight",
   "editor.action.addCommentLine",
   "editor.action.addCursorsToBottom",
   "editor.action.addCursorsToTop",
   "editor.action.addSelectionToNextFindMatch",
   "editor.action.addSelectionToPreviousFindMatch",
   "editor.action.blockComment",
   "editor.action.clipboardCopyWithSyntaxHighlightingAction",
   "editor.action.commentLine",
   "editor.action.copyLinesDownAction",
   "editor.action.copyLinesUpAction",
   "editor.action.deleteLines",
   "editor.action.detectIndentation",
   "editor.action.duplicateSelection",
   "editor.action.fontZoomIn",
   "editor.action.fontZoomOut",
   "editor.action.fontZoomReset",
   "editor.action.formatDocument",
   "editor.action.formatSelection",
   "editor.action.gotoLine",
   "editor.action.goToReferences",
   "editor.action.indentationToSpaces",
   "editor.action.indentationToTabs",
   "editor.action.indentLines",
   "editor.action.indentUsingSpaces",
   "editor.action.indentUsingTabs",
   "editor.action.inPlaceReplace.down",
   "editor.action.inPlaceReplace.up",
   "editor.action.insertCursorAbove",
   "editor.action.insertCursorAtEndOfEachLineSelected",
   "editor.action.insertCursorBelow",
   "editor.action.insertLineAfter",
   "editor.action.insertLineBefore",
   "editor.action.inspectTokens",
   "editor.action.joinLines",
   "editor.action.jumpToBracket",
   "editor.action.marker.next",
   "editor.action.marker..",
   "editor.action.marker.prev",
   "editor.action.marker.prevInFiles",
   "editor.action.moveCarretLeftAction",
   "editor.action.moveCarretRightAction",
   "editor.action.moveLinesDownAction",
   "editor.action.moveLinesUpAction",
   "editor.action.moveSelectionToNextFindMatch",
   "editor.action.moveSelectionToPreviousFindMatch",
   "editor.action.nextMatchFindAction",
   "editor.action.nextSelectionMatchFindAction",
   "editor.action.onTypeRename",
   "editor.action.openLink",
   "editor.action.outdentLines",
   "editor.action.peekDefinition",
   "editor.action.previousMatchFindAction",
   "editor.action.previousSelectionMatchFindAction",
   "editor.action.quickCommand",
   "editor.action.quickFix",
   "editor.action.quickOutline",
   "editor.action.refactor",
   "editor.action.referenceSearch.trigger",
   "editor.action.reindentlines",
   "editor.action.reindentselectedlines",
   "editor.action.removeCommentLine",
   "editor.action.rename",
   "editor.action.revealDefinition",
   "editor.action.revealDefinitionAside",
   "editor.action.selectHighlights",
   "editor.action.selectToBracket",
   "editor.action.setSelectionAnchor",
   "editor.action.showAccessibilityHelp",
   "editor.action.showContextMenu",
   "editor.action.showDefinitionPreviewHover",
   "editor.action.showHover",
   "editor.action.smartSelect.expand",
   "editor.action.smartSelect.shrink",
   "editor.action.sortLinesAscending",
   "editor.action.sortLinesDescending",
   "editor.action.sourceAction",
   "editor.action.startFindReplaceAction",
   "editor.action.toggleHighContrast",
   "editor.action.toggleTabFocusMode",
   "editor.action.transformToLowercase",
   "editor.action.transformToTitlecase",
   "editor.action.transformToUppercase",
   "editor.action.transpose",
   "editor.action.transposeLetters",
   "editor.action.triggerParameterHints",
   "editor.action.triggerSuggest",
   "editor.action.trimTrailingWhitespace",
   "editor.action.wordHighlight.trigger",
   "editor.fold",
   "editor.foldAll",
   "editor.foldAllBlockComments",
   "editor.foldAllMarkerRegions",
   "editor.foldLevel1",
   "editor.foldLevel2",
   "editor.foldLevel3",
   "editor.foldLevel4",
   "editor.foldLevel5",
   "editor.foldLevel6",
   "editor.foldLevel7",
   "editor.foldRecursively",
   "editor.toggleFold",
   "editor.unfold",
   "editor.unfoldAll",
   "editor.unfoldAllMarkerRegions",
   "editor.unfoldRecursively"
 ]
 */

//    class func hex_code_sec_1_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let fontPlusCommand =
//            UIKeyCommand(title: NSLocalizedString("Font Increase", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.code_menu_increase_font_action(_:)),
//                         input: "]",
//                         modifierFlags: .command,
//                         propertyList: nil)
//        menu_children.append(fontPlusCommand)
//        let fontMinusCommand =
//            UIKeyCommand(title: NSLocalizedString("Font Decrease", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.code_menu_decrease_font_action(_:)),
//                         input: "[",
//                         modifierFlags: .command,
//                         propertyList: nil)
//        menu_children.append(fontMinusCommand)
//        let Menu = UIMenu(title: "Font Size",
//                                    image: nil,
//                                    identifier: UIMenu.Identifier("code_sec1_items"),
//                                    options: [],
//                                    children: menu_children)
//        return Menu
//    }
//
//    class func hex_code_sec_2_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let autoIndentCommand =
//            UIKeyCommand(title: NSLocalizedString("Beautify", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.code_menu_beautify_action(_:)),
//                         input: "i",
//                         modifierFlags: .control,
//                         propertyList: nil)
//        menu_children.append(autoIndentCommand)
//        let Menu = UIMenu(title: "",
//                                    image: nil,
//                                    identifier: UIMenu.Identifier("hex_code_sec_2_menu_items"),
//                                    options: .displayInline,
//                                    children: menu_children)
//        return Menu
//    }
//
//
//
//
//
//
//    class func hex_preview_menu() -> UIMenu {
//        let Menu =
//            UIMenu(title: "Preview",
//                   image: nil,
//                   identifier: UIMenu.Identifier("preview_parent_menu"),
//                   options: [],
//                   children: [])
//        return Menu
//    }
//
//
//
//
//
//    class func hex_preview_sec_1_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let previewBrowserCommand =
//            UIKeyCommand(title: NSLocalizedString("In Browser", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuWebViewActionProtocol.preview_menu_browser_action(_:)),
//                         input: "R",
//                         modifierFlags: .command,
//                         propertyList: nil)
//        menu_children.append(previewBrowserCommand)
//        let hidePreviewCommand =
//            UIKeyCommand(title: NSLocalizedString("Hide", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuWebViewActionProtocol.preview_menu_hide_action(_:)),
//                         input: "H",
//                         modifierFlags: .alternate,
//                         propertyList: ["togglePreview", "button"])
//        menu_children.append(hidePreviewCommand)
//        let Menu =
//            UIMenu(title: "",
//                   image: nil,
//                   identifier: UIMenu.Identifier("preview_sec1_items"),
//                   options: .displayInline,
//                   children: menu_children)
//        return Menu
//    }
//
//
//
//    class func hex_preview_sec_2_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let nilDelayCommand =
//            UICommand(title: NSLocalizedString("Instant", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.preview_update_delay_instant(_:)),
//                         propertyList: ["delay", "0"])
//        menu_children.append(nilDelayCommand)
//        let twoSecDelayCommand =
//            UICommand(title: NSLocalizedString("2s Delay", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.preview_update_delay_2s(_:)),
//                         propertyList: ["delay", "2"])
//        menu_children.append(twoSecDelayCommand)
//        let fiveSecDelayCommand =
//            UICommand(title: NSLocalizedString("5s Delay", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.preview_update_delay_5s(_:)),
//                         propertyList: ["delay", "5"])
//        menu_children.append(fiveSecDelayCommand)
//        let tenSecDelayCommand =
//            UICommand(title: NSLocalizedString("10s Delay", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.preview_update_delay_10s(_:)),
//                         propertyList: ["delay", "10"])
//        menu_children.append(tenSecDelayCommand)
//        let Menu = UIMenu(title: "Update Delay",
//                                    image: nil,
//                                    identifier: UIMenu.Identifier("preview_se2_items"),
//                                    options: [],
//                                    children: menu_children)
//        return Menu
//    }
//
//
//
//
//
//    class func hex_connection_sec_1_menu() -> UIMenu {
//        var file_menu_children:[UIMenuElement] = []
//        let openCommand =
//            UIKeyCommand(title: NSLocalizedString("FTP Settings", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuBrowserActionProtocol.connection_menu_ftp_action(_:)),
//                         input: "",
//                         propertyList: nil)
//        file_menu_children.append(openCommand)
//        let Menu =
//            UIMenu(title: "Connections",
//                   image: nil,
//                   identifier: UIMenu.Identifier("connection_sec1_items"),
//                   options: [],
//                   children: file_menu_children)
//        return Menu
//    }


//
//
//
//
//
//
//
//    class func hex_insert_menu() -> UIMenu {
//        let Menu =
//            UIMenu(title: "Insert",
//                   image: nil,
//                   identifier: UIMenu.Identifier("insert_menu"),
//                   options: [],
//                   children: [])
//        return Menu
//    }
//
//
//    class func hex_insert_sec_1_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let commentCommand =
//            UIKeyCommand(title: NSLocalizedString("Comment", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_comment_block_action(_:)),
//                         input: "/",
//                         modifierFlags: .command,
//                         propertyList: nil)
//        menu_children.append(commentCommand)
//        let Menu =
//            UIMenu(title: "",
//                   image: nil,
//                   identifier: UIMenu.Identifier("insert_sec1_items"),
//                   options: .displayInline,
//                   children: menu_children)
//        return Menu
//    }
//
//
//    class func hex_insert_sec_1_meta_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let styleMetaCommand =
//            UICommand(title: NSLocalizedString("Inline CSS", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_meta_inlineCSS_action(_:)),
//                         propertyList: nil)
//        menu_children.append(styleMetaCommand)
//        let inlineJSCommand =
//            UICommand(title: NSLocalizedString("Inline JS", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_meta_inlineJS_action(_:)),
//                         propertyList: nil)
//        menu_children.append(inlineJSCommand)
//        let Menu = UIMenu(title: "Meta Tags INLINE",
//                                    image: nil,
//                                    identifier: UIMenu.Identifier("insert_sec1_meta_items"),
//                                    options: .displayInline,
//                                    children: menu_children)
//        return Menu
//    }
//
//    class func hex_insert_sec_2_meta_menu() -> UIMenu {
//        var menu_children:[UIMenuElement] = []
//        let styleMetaCommand =
//            UICommand(title: NSLocalizedString("Style", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_meta_linkCSS_action(_:)),
//                         propertyList: nil)
//        menu_children.append(styleMetaCommand)
//        let metaJSCommand =
//            UICommand(title: NSLocalizedString("Script", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_meta_linkJS_action(_:)),
//                         propertyList: nil)
//        menu_children.append(metaJSCommand)
//        let metaTitleCommand =
//            UICommand(title: NSLocalizedString("Title", comment: ""),
//                         image: nil,
//                         action: #selector(HEXMainMenuActionProtocol.insert_menu_meta_title_action(_:)),
//                         propertyList: ["title", "test"])
//        menu_children.append(metaTitleCommand)
//        let Menu = UIMenu(title: "Meta Tags",
//                                    image: nil,
//                                    identifier: UIMenu.Identifier("insert_sec2_meta_items"),
//                                    options: [],
//                                    children: menu_children)
//        return Menu
//    }
//
//
//
//
//
