//
//  TXTVars.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import Foundation
import UIKit

public let environment             : BANAPPENV = .develop
public let app_group               : String            = "group.com.int.TextEditor"
public var APP_FOLDER_NAME         : String            = "BAN"
public var APPNAME                 : String            = "Text Editor"
public let XPref                   = BANPreference()

public enum BANAPPENV {
    case develop
    case production
}

public enum BANError: Error{
    case no_webview
    case missing_url
    case error_doc
    case generic(txt: String)
}

extension BANError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .no_webview:
            return NSLocalizedString("Missing Editor", comment: "Missing Editor")
        case .missing_url:
            return NSLocalizedString("Missing URL", comment: "Missing URL")
        case .error_doc:
            return NSLocalizedString("Document management error", comment: "Document management error")
        case .generic(txt: let txt):
            return txt
        }
    }
}


public enum BANAppearance: Int {
    case UseSystem  = 0
    case DarkMode   = 1
    case LightMode  = 2
    
    func get_name() -> String{
        var ret = "Use System"
        switch self {
        case .UseSystem:
            ret = "Use System"
            break
        case .DarkMode:
            ret = "Dark Mode"
            break
        case .LightMode:
            ret = "Light Mode"
            break
        }
        return ret
    }
    
    func get_ui_style() -> UIUserInterfaceStyle{
        var a = UIUserInterfaceStyle.unspecified
        switch self {
        case .UseSystem:
            a = .unspecified
            break
        case .DarkMode:
            a = .dark
            break
        case .LightMode:
            a = .light
            break
        }
        return a

    }
}

//enum TXTTheme : String, CaseIterable{
//    case vs     = "vs"
//    case vsdark = "vs-dark"
//    case hcdark = "hc-black"
//
//    func get_name() -> String{
//        switch self{
//        case .vs:
//            return "Light"
//        case .vsdark:
//            return "Dark"
//        case .hcdark:
//            return "High Contrast Dark"
//        }
//    }
//}


////https://microsoft.github.io/monaco-editor/
//enum TXTLang: String, CaseIterable{
//    case js         = "javascript"
//    case ts         = "typescript"
//    case html       = "html"
//    case css        = "css"
//    case clojure    = "clojure"
//    case cpp        = "cpp"
//    case csharp     = "csharp"
//    case dockerfile = "dockerfile"
//    case go         = "go"
//    case graphql    = "graphql"
//    case ini        = "ini"
//    case java       = "java"
//    case json       = "json"
//    case kotlin     = "kotlin"
//    case lua        = "lua"
//    case markdown   = "markdown"
//    case mysql      = "mysql"
//    case objectivec = "objective-c"
//    case pascal     = "pascal"
//    case perl       = "perl"
//    case pgsql      = "pgsql"
//    case php        = "php"
//    case plaintex   = "plaintext"
//    case powershell = "powershell"
//    case pug        = "pug"
//    case python     = "python"
//    case redis      = "redis"
//    case ruby       = "ruby"
//    case rust       = "rust"
//    case scala      = "scala"
//    case shell      = "shell"
//    case sql        = "sql"
//    case swift      = "swift"
//    case vb         = "vb"
//    case xml        = "xml"
//    case yaml       = "yaml"
//
//    static var get_langs: [TXTLang] {
//        TXTLang.allCases.sorted { l1, l2 in
//            l1.rawValue < l2.rawValue
//        }
//    }
//
//    static var get_exts: [String] {
//        get_langs.compactMap { lang in
//            lang.get_ext().first
//        }
//    }
//
//    static var get_exts_save_panel: [String] {
//        var extensions = TXTLang.get_exts
//        extensions.insert("html", at: 0) //forze html to be first so is saved
//        extensions = extensions.unique()
//        return extensions
//    }
//
//
//    static func check_ext(_ ext: String) -> TXTLang? {
//        let extl = ext.lowercased()
//        return get_langs.first(where: { lang in
//            lang.get_ext().contains(extl)
//        })
//    }
//
//    func get_ext() -> [String] {
//        var ext = [String]()
//        switch self {
//
//        case .js:
//            ext = ["js","javascript"]
//        case .ts:
//            ext = ["ts","typescript"]
//        case .html:
//            ext = ["htm","html"]
//        case .css:
//            ext = ["css"]
//        case .clojure:
//            ext = ["clj","cljs", "cljc"]
//        case .cpp:
//            ext = ["cpp","c"]
//        case .csharp:
//            ext = ["cs"]
//        case .dockerfile:
//            ext = ["docker"]
//        case .go:
//            ext = ["go"]
//        case .graphql:
//            ext = ["docker"]
//        case .ini:
//            ext = ["ini"]
//        case .java:
//            ext = ["java"]
//        case .json:
//            ext = ["json"]
//        case .kotlin:
//            ext = ["kt","kts"]
//        case .lua:
//            ext = ["lua"]
//        case .markdown:
//            ext = ["md","markdown"]
//        case .mysql:
//            ext = ["sql"]
//        case .objectivec:
//            ext = ["m","mm"]
//        case .pascal:
//            ext = ["pp"]
//        case .perl:
//            ext = ["pl"]
//        case .pgsql:
//            ext = ["psql"]
//        case .php:
//            ext = ["php"]
//        case .plaintex:
//            ext = ["txt"]
//        case .powershell:
//            ext = ["ps1"]
//        case .pug:
//            ext = ["pug"]
//        case .python:
//            ext = ["ppy"]
//        case .redis:
//            ext = ["rdb"]
//        case .ruby:
//            ext = ["rb"]
//        case .rust:
//            ext = ["rs"]
//        case .scala:
//            ext = ["sc"]
//        case .shell:
//            ext = ["sh","csh","bash"]
//        case .sql:
//            ext = ["sql"]
//        case .swift:
//            ext = ["swift"]
//        case .vb:
//            ext = ["vb"]
//        case .xml:
//            ext = ["xml"]
//        case .yaml:
//            ext = ["yaml"]
//        }
//        return ext
//    }
//}

/*
<select class="language-picker">
<option>abap</option>
<option>aes</option>
<option>apex</option>
<option>azcli</option>
<option>bat</option>
<option>bicep</option>
<option>c</option>
<option>cameligo</option>
<option>clojure</option>
<option>coffeescript</option>
<option>cpp</option>
<option>csharp</option>
<option>csp</option>
<option>css</option>
<option>dart</option>
<option>dockerfile</option>
<option>ecl</option>
<option>elixir</option>
<option>flow9</option>
<option>freemarker2</option>
<option>freemarker2.tag-angle.interpolation-bracket</option>
<option>freemarker2.tag-angle.interpolation-dollar</option>
<option>freemarker2.tag-auto.interpolation-bracket</option>
<option>freemarker2.tag-auto.interpolation-dollar</option>
<option>freemarker2.tag-bracket.interpolation-bracket</option>
<option>freemarker2.tag-bracket.interpolation-dollar</option>
<option>fsharp</option>
<option>go</option>
<option>graphql</option>
<option>handlebars</option>
<option>hcl</option>
<option>html</option>
<option>ini</option>
<option>java</option>
<option>javascript</option>
<option>json</option>
<option>julia</option>
<option>kotlin</option>
<option>less</option>
<option>lexon</option>
<option>liquid</option>
<option>lua</option>
<option>m3</option>
<option>markdown</option>
<option>mips</option>
<option>msdax</option>
<option>mysql</option>
<option>objective-c</option>
<option>pascal</option>
<option>pascaligo</option>
<option>perl</option>
<option>pgsql</option>
<option>php</option>
<option>pla</option>
<option>plaintext</option>
<option>postiats</option>
<option>powerquery</option>
<option>powershell</option>
<option>proto</option>
<option>pug</option>
<option>python</option>
<option>qsharp</option>
<option>r</option>
<option>razor</option>
<option>redis</option>
<option>redshift</option>
<option>restructuredtext</option>
<option>ruby</option>
<option>rust</option>
<option>sb</option>
<option>scala</option>
<option>scheme</option>
<option>scss</option>
<option>shell</option>
<option>sol</option>
<option>sparql</option>
<option>sql</option>
<option>st</option>
<option>swift</option>
<option>systemverilog</option>
<option>tcl</option>
<option>twig</option>
<option>typescript</option>
<option>vb</option>
<option>verilog</option>
<option>xml</option>
<option>yaml</option>
</select>
*/
