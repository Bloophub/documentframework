//
//  BanSceneIdentifier.swift
//  Banana
//
//  Created by Giovanni Simonicca on 7/10/22.
//

import Foundation
import UIKit

public enum BANActivityIdentifier: String {
    case document          = "document"
    case file_browser      = "file_browser"
    case preferences       = "preferences"
    case alert_window      = "alert_window"

    public func sceneConfiguration() -> UISceneConfiguration {
        switch self {
        case .document:
            return UISceneConfiguration(
                name: BANSceneConfiguration.document_config.rawValue,
                sessionRole: .windowApplication
            )
        case .file_browser:
            return UISceneConfiguration(
                name: BANSceneConfiguration.default_config.rawValue,
                sessionRole: .windowApplication
            )
        case .preferences:
            return UISceneConfiguration(
                name: BANSceneConfiguration.preferences_config.rawValue,
                sessionRole: .windowApplication
            )
        case .alert_window:
            return UISceneConfiguration(
                name: BANSceneConfiguration.alert_config.rawValue,
                sessionRole: .windowApplication
            )
        }
    }
}


public enum BANSceneConfiguration: String{
    case alert_config           = "Alert Configuration"
    case document_config        = "Document Configuration"
//    case new_document_config    = "New Document Configuration"
    case default_config         = "Default Configuration"
    case preferences_config     = "Preferences Configuration"
}

public enum BANSceneKeys: String{
    case doc_url            = "doc_url"
    case open_url           = "open_url"
    
}
