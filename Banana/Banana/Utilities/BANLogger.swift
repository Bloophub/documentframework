//
//  AMZLogger.swift
//  Zero
//
//  Created by Drain on 29/07/2018.
//  Copyright © 2018 Bloop. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift

public let ALog = BANLogger.shared()
public class BANLogger {
    private static var sharedLogger: BANLogger = {
        let networkManager = BANLogger()
        return networkManager
    }()
    
    public class func shared() -> BANLogger {
        return sharedLogger
    }
    private var log_run = 0
    var fileLogger: DDFileLogger?
    var environment: BANAPPENV = .develop
    
    //#if os(OSX)
    public func create_logger(env: BANAPPENV){
       
        environment     = env
        
        dynamicLogLevel = DDLogLevel.info
        
        #if DEBUG
        dynamicLogLevel = DDLogLevel.verbose
        #endif

        #if DEBUG
        asyncLoggingEnabled = false
        #endif
        
        if environment == .production {
            dynamicLogLevel = DDLogLevel.warning
        }
        update_log_run()
        
        let formatter = AMZLogFormatter()
        formatter.run = log_run
        
        DDOSLogger.sharedInstance.logFormatter = formatter
        DDLog.add(DDOSLogger.sharedInstance) // TTY = Xcode console

//        #if DEBUG
//            DDTTYLogger.sharedInstance?.logFormatter = formatter
//            DDLog.add(DDOSLogger.sharedInstance) // TTY = Xcode console
//        #else
//            if env != AMZEnvironment.prd {
//                //                        #if DEBUG
//                //                        DDASLLogger.sharedInstance.logFormatter = formatter
//                //                        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
//                //                        #endif
//                DDTTYLogger.sharedInstance?.logFormatter = formatter
//                DDLog.add(DDOSLogger.sharedInstance) // TTY = Xcode console
//            }
//        #endif
        
        let fileLoggerx = DDFileLogger() // File Logger
        fileLoggerx.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLoggerx.logFileManager.maximumNumberOfLogFiles = 3
        fileLoggerx.logFormatter = formatter
        DDLog.add(fileLoggerx)
        fileLogger = fileLoggerx
    }
//    #else
//    var sub_logger: STRLogProtocol?
//    func create_logger_ios(_ sub_logger : STRLogProtocol){
//        update_log_run()
//        self.sub_logger      = sub_logger
//    }
//    #endif
    
    private func update_log_run(){
        log_run = UserDefaults.standard.integer(forKey: "xlog_run") + 1
        UserDefaults.standard.set(log_run, forKey: "xlog_run")
        UserDefaults.standard.synchronize()
    }
    
//    #if os(OSX)
    @objc public func log_error(_ log: String){
        DDLogError(log)
    }
    @objc public func log_info(_ log: String){
        DDLogInfo(log)
    }
    @objc public func log_warn(_ log: String){
        DDLogWarn(log)
    }
    @objc public func log_exception(_ log: String){
        DDLogError(log)
    }
    @objc public func log_verbose(_ log: String){
        DDLogVerbose(log)
    }
    
    public func track(_ text : String, customAttributes: [String:String]? = nil){
        //let log = "\(XConfig.app_version ?? "")] \(text)"
        //Answers.logCustomEvent(withName: log, customAttributes: customAttributes)
        #if DEBUG
       
        #else
        //Analytics.trackEvent(text, withProperties: customAttributes)
        #endif
    }
}

public class AMZLogFormatter: NSObject, DDLogFormatter {
    
    let dateFormatter: DateFormatter
    var run = 0
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.formatterBehavior = .behavior10_4
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        super.init()
    }
    public func format(message logMessage: DDLogMessage) -> String? {
        return "[\(run)] \(logMessage.message)"
//        let dateAndTime = dateFormatter.string(from: logMessage.timestamp)
//        return "[\(run)] \(dateAndTime) [\(logMessage.fileName):\(logMessage.function!):\(logMessage.line)]: \(logMessage.message)"
    }
    
    //     func format(message: DDLogMessage) -> String {
    //        let dateAndTime = dateFormatter.string(from: message.timestamp)
    //        return "\(dateAndTime) [\(message.fileName!) \(message.function!):\(message.line)] \(message.message ?? "")"
    //    }
}

//import UIKit
//import CocoaLumberjack
//import CocoaLumberjackSwift

public class BANLogFormatter : NSObject,DDLogFormatter
{
    public func format(message logMessage: DDLogMessage) -> String? {
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
