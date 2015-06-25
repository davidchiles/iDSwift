//
//  Parser.swift
//  Pods
//
//  Created by David Chiles on 5/22/15.
//
//

import Foundation


public class PresetParser {
    
    public class func parseAllPresets(queue: dispatch_queue_t = dispatch_get_main_queue(), foundPreset: (preset: Preset) -> Void, completion: () -> Void) {
        
        if let tempPath = NSBundle(forClass: self).pathForResource("PresetsInfo", ofType: "bundle")?.stringByAppendingPathComponent("presets.json") {
            if let data = NSData(contentsOfFile: tempPath) {
                if let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as? Dictionary<String, AnyObject> {
                    println("Stop me: \(count(jsonDict))")
                }
            }
        }
        
        
        var resourcePath = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle")
        if  let directory = resourcePath {
            if let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(directory) {
                var group = dispatch_group_create()
                while var file: AnyObject = fileEnumerator.nextObject() {
                    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        if let fileString :String = file as? String {
                            var fullPath = String.pathWithComponents([directory,fileString]);
                            if let data = NSData(contentsOfFile: fullPath) {
                                if let preset = self.parseJSONData(data) {
                                    dispatch_group_async(group, queue, { () -> Void in
                                        foundPreset(preset: preset)
                                    })
                                }
                            }
                        }
                    })
                }
                dispatch_group_notify(group, queue, completion)
            }
        }
    }
    
    class func parseJSONData(jsonData: NSData) -> Preset? {
        if let jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.allZeros, error: nil) as? Dictionary<String, AnyObject> {
            return Preset(presetJSONDictionary: jsonObject);
        }
        
        return nil;
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
            if let path = NSBundle(forClass: self).pathForResource("PresetsInfo", ofType: "bundle")?.stringByAppendingPathComponent("categories.json") {
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