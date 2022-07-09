//
//  LogFormatter.swift
//  Calculator
//
//  Created by Alec Isherwood on 05/03/2021.
//

import UIKit
import CocoaLumberjack
//import CocoaLumberjackSwift

class LogFormatter : NSObject,DDLogFormatter
{
    func format(message logMessage: DDLogMessage) -> String? {
        return "[\(logMessage.fileName):\(logMessage.function!):\(logMessage.line) \(stringForLogLevel(logLevel: logMessage.level))]: \(logMessage.message)"
    }


    private func stringForLogLevel(logLevel:DDLogLevel) -> String
    {
        switch(logLevel)
        {
        case .error:
            return "E";
        case .warning:
            return "W";
        case .info:
            return "I";
        case .debug:
            return "D";
        case .verbose:
            return "V";
        default:
            break;
        }
        return ""
    }
}
