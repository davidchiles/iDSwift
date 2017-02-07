//
//  Parser.swift
//  Pods
//
//  Created by David Chiles on 5/22/15.
//
//

import Foundation

enum ParseError: Error {
    case InvalidJSONStructure
    case UnableToLoadData
}

public class Parser {
    internal class func parseJSONFile(bundleName:String, fileName:String) throws ->  Any {
        guard let url = Bundle(for: self).url(forResource: bundleName, withExtension: "bundle")?.appendingPathComponent(fileName+".json"),
            let data = try? Data(contentsOf: url) else  {
            throw ParseError.UnableToLoadData
        }
        return try JSONSerialization.jsonObject(with: data, options: [])
    }
    
    internal class func parseJSONArray<T>(bundleName:String, fileName:String, transform:(Any)->T?) throws -> [T] {
        guard let jsonObject = try self.parseJSONFile(bundleName: bundleName, fileName: fileName) as? Array<Any> else {
            throw ParseError.InvalidJSONStructure
        }
        return jsonObject.map(transform).flatMap( { $0 })
    }
    
    internal class func parseJSONDict<T>(bundleName:String, fileName:String, transform:(_ key:String,_ value:Any)->T?) throws -> [T] {
        guard let jsonObject = try self.parseJSONFile(bundleName: bundleName, fileName: fileName) as? Dictionary<String,Any> else {
            throw ParseError.InvalidJSONStructure
        }
        return jsonObject.map(transform).flatMap( { $0 })
    }
}

extension Parser {
    
    public class func parseAllPresets() throws -> [Preset] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "presets", transform: { (key, value) -> Preset? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return Preset(presetJSONDictionary: dict)
        })
    }
    
    public class func parseAllDeprecatedTags() throws -> [DeprecatedTag] {
        return try self.parseJSONArray(bundleName: "Data", fileName: "deprecated", transform: { (object) -> DeprecatedTag? in
            guard let dict = object as? Dictionary<String, Dictionary<String, String>>,let oldTags = dict["old"],let newTags = dict["replace"] else {
                return nil
            }
            return DeprecatedTag(oldTags: oldTags, newTags: newTags)
        })
    }
    
    public class func parseAllPresetCategories() throws -> [PresetCategory] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "categories", transform: { (key, value) -> PresetCategory? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return PresetCategory(categoryDictionary: dict)
        })
    }
    
    public class func parseAllPresetFields() throws -> [PresetField] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "fields", transform: { (key, value) -> PresetField? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return PresetField(fieldDictionary: dict)
        })
    }
    
    public class func parseDiscarded() throws -> [String] {
        return try self.parseJSONArray(bundleName: "Data", fileName: "discarded", transform: { (value) -> String? in
            if let str = value as? String {
                return str
            }
            return nil
        })
    }
}
