//
//  Extensions.swift
//  HexCharlie
//
//  Created by Alec Isherwood on 04/04/2022.
//

import Foundation
import UIKit
import WebKit
import UniformTypeIdentifiers

extension String {
    var URLEncoded:String {

        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharsSet: CharacterSet = CharacterSet(charactersIn: unreservedChars)
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: unreservedCharsSet)!
        return encodedString
    }
}

extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd:  Bool { !isEven }
}

extension UIColor{
    func image(_ size: CGSize = CGSize(width: 16, height: 16)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
    func colorWith(brightness: CGFloat) -> UIColor{
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r + brightness, 0.0), green: max(g + brightness, 0.0), blue: max(b + brightness, 0.0), alpha: a)
        }
        return UIColor()
    }
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

extension Bundle {
    var app_name: String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    static var isiOS: Bool {
        return TARGET_OS_IOS != 0
    }
    static var isCatalyst: Bool{
        #if targetEnvironment(macCatalyst)
            return true
        #else
            return false
        #endif
    }
    static var isMac: Bool{
        return UIDevice.current.userInterfaceIdiom == .mac //catalyst ios app run on m1 notebook
    }
    static var isPad: Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    static var isPhone: Bool{
        return UIDevice.current.userInterfaceIdiom != .pad && isCatalyst == false && isiOS == true
    }
    
    static var hasSceneSupport: Bool {
        return UIApplication.shared.supportsMultipleScenes
    }
    
    static var isNotMac: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .phone
    }

}

public extension UIView {

/**
 Fade in a view with a duration
 
 - parameter duration: custom animation duration
 */
    func fadeIn(duration: TimeInterval = 1.0, alphaLevel: CGFloat = 1) {
     UIView.animate(withDuration: duration, animations: {
        self.alpha = alphaLevel
     })
 }

/**
 Fade out a view with a duration
 
 - parameter duration: custom animation duration
 */
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
      }
    
    func fadeOut(duration: TimeInterval = 1.0, alphaLevel: CGFloat = 1) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alphaLevel
        })
      }

}

extension Array {
    subscript (safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }
}

extension URLFileResourceType: Codable {
    func get_Name(_ type: String) -> String {
        switch URLFileResourceType.init(rawValue: type) {
            
        case .directory:
            return "Dir"
        case .regular:
            return "File"
            
        default:
            return "Unknown"
        }
    }
 }

@IBDesignable open class PaddingLabel: UILabel {
    
    @IBInspectable open var topInset: CGFloat = 5.0
    @IBInspectable open var bottomInset: CGFloat = 5.0
    @IBInspectable open var leftInset: CGFloat = 7.0
    @IBInspectable open var rightInset: CGFloat = 7.0
    
    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    open override var bounds: CGRect {
        didSet {
            // Supported Multiple Lines in Stack views
//            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

extension NSObject {
    static func util_mt(_ block: @escaping (()->())) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    static func util_mt_wait(_ block: @escaping (()->())) {
        if Thread.isMainThread == false {
            let semaphore = DispatchSemaphore(value: 0);
            DispatchQueue.main.async {
                block()
                semaphore.signal();
            }
            semaphore.wait()
        } else {
            block()
        }
    }
}


extension Array {
    func chunks(_ chunkSize: UInt) -> [[Element]] {
        let cs = Int(chunkSize)
        return stride(from: 0, to: self.count, by: cs).map {
            Array(self[$0..<Swift.min($0 + cs, self.count)])
        }
    }
    mutating func remove (at ixs:[Int]) -> () {
        for i in ixs.sorted(by: >) {
            self.remove(at:i)
        }
    }
}
extension Array where Element: AnyObject {
    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.firstIndex(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    mutating func remove(object: AnyObject) {
        if let index = firstIndex(where: { $0 as AnyObject? === object }) {
            remove(at: index)
        }else{
            ALog.log_verbose("cannot find \(object)")
        }
    }
    mutating func remove(objects: [AnyObject]) {
        for object in objects{
            remove(object: object)
        }
    }
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    typealias Element = Iterator.Element
    func unique<Key: Hashable>(by key: (Element) -> (Key)) -> [Element] {
        var seen = Set<Key>()
        return filter {
            seen.update(with: key($0)) == nil
        }
    }
}
extension Collection {
    func insertionIndex(of element: Self.Iterator.Element,
                        using areInIncreasingOrder: (Self.Iterator.Element, Self.Iterator.Element) -> Bool) -> Index {
        return firstIndex(where: { !areInIncreasingOrder($0, element) }) ?? endIndex
    }
}

extension Array where Element: Equatable{
    mutating func util_move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.util_move(from: oldIndex, to: newIndex) }
    }
}

extension Array
{
    mutating func util_move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

extension Date {
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
}

//extension Scanner {
//    func scan_up_and_scan(_ string: String, into result: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool{
//        if scanUpTo(string, into: nil){
//            //se fallisce o riesce cmq sono all inizio della stringa
//        }
//        return scanString(string, into: result)
//    }
//}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}


extension Dictionary {
    var prettyPrintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch _ {
            return nil
        }
    }
}


extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}


import MobileCoreServices

extension URL {
    var mimeType: String {
        return UTType(filenameExtension: self.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
    
    var getUTType: UTType? {
        if self.lastPathComponent.contains(".") == false {
            return .directory
        }
        return UTType(filenameExtension: self.pathExtension)
    }
    
    func contains(_ uttype: UTType) -> Bool {
        return UTType(mimeType: self.mimeType)?.conforms(to: uttype) ?? false
    }
    var containsImage: Bool {
        return self.contains(.image)
    }
    var containsAudio: Bool {
        return self.contains(.audio)
    }
    var containsVideo: Bool {
        return self.contains(.video)
    }
    var containsArchive: Bool {
        return self.contains(.archive)
    }
    var isTextBased: Bool {
        return getUTType?.isSubtype(of: .text) ?? false
    }
    
    var getType: UTType {
        return self.getUTType ?? .item
    }
    
//    var getCategory: EnumManager.drag_drop_type {
//        if self.isTextBased {
//            return .text
//        } else if self.containsImage {
//            return .image
//        } else if self.containsAudio {
//            return .audio
//        } else if self.containsVideo {
//            return .video
//        } else if self.containsArchive {
//            return .archive
//        } else {
//            return .unknown
//        }
//    }
}

extension UIAlertController {
    
    @objc func textDidChangeFieldEmptyCheck() {
        let original_message = message
        if let field = textFields?[0].text,
            let action = actions.first {
            action.isEnabled = field == "" ? false : true
            message = field == "" ? "Please enter a value" : original_message
        }
    }
    
}

extension UIApplication {
    class func get_key_window() -> UIWindow?{
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return keyWindow
    }

}

extension UIResponder {
    func responderChain() -> String {
        func desc_self() -> String{
            return xclassName + ":\(self.isFirstResponder)\n"
        }
        guard let next = next else {
            return desc_self()
        }
        return desc_self() + " -> " + next.responderChain()
        
    }
}

extension Bundle {
    public var app_iconx: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

extension NSObject {
    var xclassName: String {
        return String(describing: type(of: self)) // Result: SomeClass
    }
}
