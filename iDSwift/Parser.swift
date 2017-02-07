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
    
    internal class func parseJSONArray<T>(bundleName:String, fileName:String, key:String?, transform:(Any) throws ->T?) throws -> [T] {
        let jsonObject = try self.parseJSONFile(bundleName: bundleName, fileName: fileName)
        
        if let jsonDict = jsonObject as? Dictionary<String,Array<Any>>, let k = key, let arr = jsonDict[k] {
            return try arr.map(transform).flatMap( { $0 })
        }
        if let jsonArray = jsonObject as? Array<Any> {
            return try jsonArray.map(transform).flatMap( { $0 })
        }
        throw ParseError.InvalidJSONStructure
    }
    
    internal class func parseJSONDict<T>(bundleName:String, fileName:String, key:String? = nil, transform:(_ key:String,_ value:Any) throws ->T?) throws -> [T] {
        guard var jsonObject = try self.parseJSONFile(bundleName: bundleName, fileName: fileName) as? Dictionary<String,Any> else {
            throw ParseError.InvalidJSONStructure
        }
        if let key = key {
            if let obj = jsonObject[key] as? Dictionary<String,Any> {
                jsonObject = obj
            }
        }
        
        return try jsonObject.map(transform).flatMap( { $0 })
    }
}

extension Parser {
    
    public class func parseAllPresets() throws -> [Preset] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "presets", key:"presets", transform: { (key, value) -> Preset? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return try Preset(presetJSONDictionary: dict)
        })
    }
    
    public class func parseAllDeprecatedTags() throws -> [DeprecatedTag] {
        return try self.parseJSONArray(bundleName: "Data", fileName: "deprecated",key:"dataDeprecated", transform: { (object) -> DeprecatedTag? in
            guard let dict = object as? Dictionary<String, Dictionary<String, String>>,let oldTags = dict["old"],let newTags = dict["replace"] else {
                return nil
            }
            return DeprecatedTag(oldTags: oldTags, newTags: newTags)
        })
    }
    
    public class func parseAllPresetCategories() throws -> [PresetCategory] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "categories", key:"categories", transform: { (key, value) -> PresetCategory? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return try PresetCategory(categoryDictionary: dict)
        })
    }
    
    public class func parseAllPresetFields() throws -> [PresetField] {
        return try self.parseJSONDict(bundleName: "Preset", fileName: "fields",key:"fields", transform: { (key, value) -> PresetField? in
            guard let dict = value as? Dictionary<String, AnyObject> else {
                return nil
            }
            return try PresetField(fieldDictionary: dict)
        })
    }
    
    public class func parseDiscarded() throws -> [String] {
        return try self.parseJSONArray(bundleName: "Data", fileName: "discarded",key:"dataDiscarded", transform: { (value) -> String? in
            if let str = value as? String {
                return str
            }
            return nil
        })
    }
}
