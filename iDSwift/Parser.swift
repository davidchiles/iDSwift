//
//  Parser.swift
//  Pods
//
//  Created by David Chiles on 5/22/15.
//
//

import Foundation


public class Parser {
    
    public class func parseAllPresets() {
        
        var resourcePath = NSBundle(forClass: self).pathForResource("Preset", ofType: "bundle");
        if  let directory = resourcePath {
            if let fileEnumerator = NSFileManager.defaultManager().enumeratorAtPath(directory) {
                while var file: AnyObject = fileEnumerator.nextObject() {
                    if let fileString :String = file as? String {
                        var fullPath = String.pathWithComponents([directory,fileString]);
                        var someData = NSData(contentsOfFile: fullPath)
                        if let data = someData {
                            if let preset = self.parseJSONData(data) {
                                println(preset)
                            }
                            
                        }
                        
                    }
                    
                }
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