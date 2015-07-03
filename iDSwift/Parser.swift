//
//  Parser.swift
//  Pods
//
//  Created by David Chiles on 5/22/15.
//
//

import Foundation

public class Parser {
    class func parseJSONFile(bundleName:String, fileName:String) -> AnyObject? {
        if let path = NSBundle(forClass: self).pathForResource(bundleName, ofType: "bundle")?.stringByAppendingPathComponent(fileName+".json") {
            if let data = NSData(contentsOfFile: path) {
                return NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil)
            }
        }
        return nil
    }
}

public class PresetParser {
    
    public class func parseAllPresets(queue: dispatch_queue_t = dispatch_get_main_queue(), foundPreset: (preset: Preset) -> Void, completion: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let tempPath = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle")?.stringByAppendingPathComponent("presets.json") {
                if let data = NSData(contentsOfFile: tempPath) {
                    if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? Dictionary<String, Dictionary<String, AnyObject>> {
                        
                        var group = dispatch_group_create()
                        
                        for (key, value) in jsonDict {
                            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                                var preset = Preset(presetJSONDictionary: value)
                                dispatch_async(queue, { () -> Void in
                                    foundPreset(preset: preset)
                                })
                            })
                        }
                        
                        dispatch_group_notify(group, queue, { () -> Void in
                            completion()
                        })
                    }
                }
            }
        })
    }
}

public class DeprecatedTagParser {
    
    public class func parseAllDeprecatedTags(queue: dispatch_queue_t = dispatch_get_main_queue(), foundDeprecatedTag: (deprecatedTag: DeprecatedTag) -> Void, completion: () -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let resourcePath = NSBundle(forClass: self).pathForResource("Data", ofType: "bundle")?.stringByAppendingPathComponent("deprecated.json") {
                if let data = NSData(contentsOfFile: resourcePath) {
                    if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? Array<Dictionary<String, Dictionary<String, String>>> {
                        
                        for dict in jsonArray {
                            if let oldTags = dict["old"] {
                                if let newTags = dict["replace"] {
                                    var deprecatedTag = DeprecatedTag(oldTags: oldTags, newTags: newTags)
                                    dispatch_async(queue, { () -> Void in
                                        foundDeprecatedTag(deprecatedTag: deprecatedTag)
                                    })
                                }
                            }
                        }
                        dispatch_async(queue, completion)
                    }
                }
            }
        })
    }
}

public class PresetCategoriesParser {
    public class func parseAllPresetCategories(queue: dispatch_queue_t = dispatch_get_main_queue(), foundPresetCategory: (category: PresetCategory) -> Void, completion: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let path = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle")?.stringByAppendingPathComponent("categories.json") {
                if let data = NSData(contentsOfFile: path) {
                    if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? Dictionary<String,Dictionary<String, AnyObject>> {
                        
                        for (key,value) in jsonDictionary {
                            var category = PresetCategory(categoryDictionary: value)
                            dispatch_async(queue, { () -> Void in
                                foundPresetCategory(category: category)
                            })
                        }
                        
                        dispatch_async(queue, completion)
                    }
                }
            }
        })
    }
}

public class PresetFieldsParser {
    public class func parseAllPresetFields(queue: dispatch_queue_t = dispatch_get_main_queue(), foundPresetField: (field: PresetField) -> Void, completion: () -> Void) {
        if let path = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle")?.stringByAppendingPathComponent("fields.json") {
            if let data = NSData(contentsOfFile: path) {
                if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? Dictionary<String,Dictionary<String, AnyObject>> {
                    
                    var typeSet = Set<String>()
                    
                    for (key, value) in jsonDictionary {
                        if let type = value["type"] as? String {
                            typeSet.insert(type)
                        }
                        
                        var field = PresetField(fieldDictionary: value)
                        foundPresetField(field: field)
                        
                    }
                    println("Types \(typeSet)")
                    completion()
                }
            }
        }
    }
}

public class DiscardedParser {
    public class func parse(queue: dispatch_queue_t = dispatch_get_main_queue(), completion: (discarded: [String]) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let discardedArray = Parser.parseJSONFile("Data",fileName: "discarded") as? [String] {
                dispatch_async(queue, { () -> Void in
                    completion(discarded: discardedArray)
                })
            }
        })
        
    }
}

