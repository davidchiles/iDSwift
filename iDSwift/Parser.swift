//
//  Parser.swift
//  Pods
//
//  Created by David Chiles on 5/22/15.
//
//

import Foundation


public class Parser {
    
    public class func parseAllPresets(queue: dispatch_queue_t = dispatch_get_main_queue(), foundPreset: (preset: Preset) -> Void, completion: () -> Void) {
        
        var resourcePath = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle");
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