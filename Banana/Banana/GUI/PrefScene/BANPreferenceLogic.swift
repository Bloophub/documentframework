//
//  VCAPreference.swift
//  VCam
//
//  Created by Giovanni Simonicca on 7/2/22.
//

import Foundation
import Dynamic
import UIKit

public let pref_noty                = NSNotification.Name(rawValue: "pref_noty")
public let pref_appearance          = "pref_appearance"

open class BANPreference {
    
    public init(){
        
    }
    
    public func set_value(_ key: String, _ value : Any){
        UserDefaults.standard.set(value, forKey: key)
        NotificationCenter.default.post(name: pref_noty, object: key)
    }
    public func get_value(_ key: String) -> Any?{
        UserDefaults.standard.object(forKey: key)
    }

    @MainActor
    public func set_appearance(_ value : BANAppearance){
        UserDefaults.standard.set(value.rawValue, forKey: pref_appearance)
        update_appearance()
    }
    
    public func update_appearance(){
        let value = get_appearance()
        let a = value.get_ui_style()
        if(BANPlatform.isPhone){
            UIApplication.get_key_window()?.overrideUserInterfaceStyle = a
            return
        }
        UIApplication.shared.connectedScenes.forEach { scene in
            guard let winsc = scene as? UIWindowScene else { return }
            winsc.windows.forEach { win in
                
//                    guard win is DocumentWindow else  { return }
                
//                    print("xxxxx xxxxx xxxxx \(a)")
//                    print("win \(win)")
                win.overrideUserInterfaceStyle = a
//                    print("win.rootViewController \(win.rootViewController)")
                win.rootViewController?.overrideUserInterfaceStyle = a
            }
        }
        
        #if targetEnvironment(macCatalyst)
            //https://github.com/mhdhejazi/Dynamic
            let app = Dynamic.NSApplication.sharedApplication
//                let cl =  NSClassFromString("NSApplication")

            var str = ""

            if a == .unspecified {
                
            }
            else if a == .dark {
                str = "NSAppearanceNameDarkAqua"
            }
            else if a == .light {
                str = "NSAppearanceNameAqua"
            }

//                2022-07-05 22:59:07.547558+0200 HTML Editor[8444:10395764] [SceneConfiguration] Info.plist configuration "Preferences Configuration" for UIWindowSceneSessionRoleApplication contained UISceneClassName key, but could not load class with name "HTML_Editor.PreferencesScene".
//                let da  = Dynamic.NSAppearanceName.darkAqua
            let appe = Dynamic.NSAppearance.appearanceNamed(str).asObject
            //Dynamic.NSApplication.sharedApplication.appearance = app
            app.appearance = appe //NSAppearance(named: .darkAqua)
        #endif

    }
    
    public func get_appearance() -> BANAppearance{
        if let i = UserDefaults.standard.object(forKey: pref_appearance) as? Int {
            return BANAppearance(rawValue: i) ?? BANAppearance.UseSystem
        }
        return BANAppearance.UseSystem
    }
}
    
//    func set_editor_preference(_ pref : TXTEditorPreference){
//        do{
//            let enc = JSONEncoder()
//            enc.outputFormatting = .prettyPrinted
//            let json: Data = try enc.encode(pref)
//            UserDefaults.standard.set(json, forKey: pref_editor_preference)
//            NotificationCenter.default.post(name: pref_noty, object: pref_editor_preference)
//        } catch{
//            ALog.log_error("set_editor_preference \(error)")
//        }
//    }
//
//    func get_editor_preference() -> TXTEditorPreference?{
//        guard let json = UserDefaults.standard.data(forKey: pref_editor_preference) else {
//            return TXTEditorPreference()
//        }
//        do{
//            let enc  = JSONDecoder()
//            return try enc.decode(TXTEditorPreference.self, from: json)
//        } catch{
//            ALog.log_error("get_editor_preference \(error)")
//        }
//        return nil
//    }
//}
//
//class TXTEditorPreference: Jsonable {
//    //"on" | "off" | "relative" | "interval" | ((lineNumber: number) => string)
////    var value           = ""
//    var fontSize        = 13
//    var language        = "javascript"
//    var automaticLayout = true
//    var theme           = "vs-dark"
//    var lineNumbers     = "on" //on off
//    var links           = true
//    //matchBrackets?: "always" | "never" | "near"
//    var matchBrackets   = "always"
//    var minimap         = TXTEditorMinimapPreference()
//
//
//}
//
////https://microsoft.github.io/monaco-editor/api/interfaces/monaco.editor.IEditorMinimapOptions.html
//class TXTEditorMinimapPreference: Jsonable {
//    var enabled = true
//    //side?: "right" | "left"
//    var side = "right"
//}
//
////    func get_auto_shutter() -> Int{
////        get_value(pref_auto_shutter) as? Int ?? 10
////    }
////    func set_auto_shutter(_ sec: Int){
////        set_value(pref_auto_shutter,sec)
////    }
////
////    func get_multiple_take_active() -> Int{
////        get_value(pref_multiple_take_active) as? Int ?? 0
////    }
////    func set_multiple_take_active(_ active: Int){
////        set_value(pref_multiple_take_active,active)
////    }
////
////    func get_multiple_take_repeat_count() -> Int{
////        get_value(pref_multiple_take_repeat_count) as? Int ?? 1
////    }
////    func set_multiple_take_repeat_count(_ count: Int){
////        set_value(pref_multiple_take_repeat_count,count)
////    }
////
////
////    //MARK: - interval
////    func get_multiple_take_interval() -> String{
////        get_value(pref_multiple_take_interval) as? String ?? "1_2" //every 2 sec
////    }
////    func set_multiple_take_interval(_ txt: String){
////        set_value(pref_multiple_take_interval,txt)
////    }
////    func get_interval_ui() -> (Int,Float)?{
////        let txt     = get_multiple_take_interval()
////        let txt_a   = txt.components(separatedBy: "_")
////        if txt_a.count == 2{
////            if let section = Int(txt_a[0]), let value = Float(txt_a[1]) {
////                return (section,value)
////            }
////        }
////        return nil
////    }
////    func get_interval_secs() -> Float?{
////        guard let tuple = get_interval_ui() else { return nil }
////        var pre: Float = 1
////        if tuple.0 == 2 { //min
////            pre = 60
////        } else if tuple.0 == 3 { //hour
////            pre = 3600
////        }
////        return pre * tuple.1
////    }
////
////
////    func get_interval_txt(_ short: Bool) -> String?{
////        var txt = ""
////        if let tuple = XPref.get_interval_ui(), let t = XPref.number_formatter.string(from: NSNumber(value: tuple.1)) {
////            txt = "\(t) "
////            if tuple.0 == 1 {       //min
////                if short {
////                    txt += "s"
////                } else{
////                    txt += tuple.1 > 1 ? "Seconds" : "Second"
////                }
////            }
////            else if tuple.0 == 2 {  //sec
////                if short {
////                    txt += "m"
////                } else{
////                    txt += tuple.1 > 1 ? "Minutes" : "Minute"
////                }
////            }
////            else if tuple.0 == 3 {  //hours
////                if short {
////                    txt += "h"
////                } else{
////                    txt += tuple.1 > 1 ? "Hours" : "Hour"
////                }
////            }
////        }
////        return txt
////    }
////
////    //MARK: - delay start
////    func get_multiple_take_delay_start() -> String{
////        get_value(pref_multiple_take_delay_start) as? String ?? "0_0" //from 1 sec
////    }
////    func set_multiple_take_delay_start(_ txt: String){
////        set_value(pref_multiple_take_delay_start,txt)
////    }
////    func get_delay_start_ui() -> (Int,Float)?{
////        let txt     = get_multiple_take_delay_start()
////        let txt_a   = txt.components(separatedBy: "_")
////        if txt_a.count == 2{
////            if let section = Int(txt_a[0]), let value = Float(txt_a[1]) {
////                return (section,value)
////            }
////        }
////        return nil
////    }
////    func get_delay_start_secs() -> Float?{
////        guard let tuple = get_delay_start_ui() else { return nil }
////        var pre: Float = 1
////        if tuple.0 == 2 { //min
////            pre = 60
////        } else if tuple.0 == 3 { //hour
////            pre = 3600
////        }
////        return pre * tuple.1
////    }
////
////
////    lazy var number_formatter: NumberFormatter = {
////        let nf = NumberFormatter()
////        nf.numberStyle = .decimal
////        nf.maximumFractionDigits = 1
////
//////        [ftDecimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//////        [ftDecimalFormatter setMaximumFractionDigits:1];
//////        [ftDecimalFormatter setMinimumFractionDigits:1];
//////        [ftDecimalFormatter setRoundingMode:NSNumberFormatterRoundUp];
////
////        return nf
////    }()
//
