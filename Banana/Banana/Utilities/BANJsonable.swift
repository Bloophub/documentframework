//
//  Jsonable.swift
//  VCam
//
//  Created by Giovanni Simonicca on 7/1/22.
//

import Foundation
public enum ban_json_error: Error{
    case json_serialize
}


public class BANCloneUtility {
    public class func xclone<T:Codable>(_ obj: T) throws -> T {
        let jsonEncoder = JSONEncoder()
        let data        = try jsonEncoder.encode(obj)
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(type(of: obj), from: data)
    }

}

//protocol Clonable {
//    func xclone() throws -> String
//}
//
//extension Clonable where Self:Codable {
//    func xclone() throws -> Self {
//        let jsonEncoder = JSONEncoder()
//        let data        = try jsonEncoder.encode(self)
//        let jsonDecoder = JSONDecoder()
//        return try jsonDecoder.decode(type(of: self), from: data)
//    }
//}

public protocol BANJsonable: Codable, CustomStringConvertible {
    func to_json() throws -> String
    func to_json_pretty() throws -> String
    func to_json_data() throws -> Data
    func to_json_dict() throws -> [String:Any]
}

extension BANJsonable {
    public func to_json() throws -> String {
//        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonString  = String(data: try to_json_data(), encoding: .utf8) ?? ""
        return jsonString
    }
    public func to_json_pretty() throws -> String {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let data = try jsonEncoder.encode(self)
        let jsonString  = String(data: data, encoding: .utf8) ?? ""
        return jsonString
    }
    public func to_json_data() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    public func to_json_dict() throws -> [String:Any] {
        guard let dict = try JSONSerialization.jsonObject(with: try to_json_data(), options: []) as? [String:Any] else {
            throw ban_json_error.json_serialize
        }
        return dict
    }
    public var description: String {
        get {
            let s = try? to_json_pretty()
            return s ?? "not convertible"
        }
    }

}

