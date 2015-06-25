//
//  Preset.swift
//  iDSwiftTest
//
//  Created by David Chiles on 5/22/15.
//  Copyright (c) 2015 David Chiles. All rights reserved.
//

import Foundation

public enum GeometryType : String, Printable {
    case None     = ""
    case Point    = "point"
    case Vertex   = "vertex"
    case Line     = "line"
    case Area     = "area"
    case Relation = "relation"
    
    public var description: String {
        return self.rawValue
    }
}

public class Preset {
    
    public var geometry = [GeometryType]()
    
    public var tags = [String:String]()
    
    public var addTags: [String:String]?
    public var removeTags: [String:String]?
    
    public var fields = [String]()
    
    public var name = String()
    
    //Default Icon from maki
    public var icon = "marker-stroked"
    
    public var searchable = true
    
    public var matchScore:Double = 1;
    
    public var terms = [String]()
    
    init(presetJSONDictionary: Dictionary<String,AnyObject>) {
        
        if let name = presetJSONDictionary["name"] as? String {
            self.name = name
        }
        
        if let fields = presetJSONDictionary["fields"] as? [String] {
            self.fields = fields
        }
        
        if let tags = presetJSONDictionary["tags"] as? [String:String] {
            self.tags = tags;
        }
        
        let removeTags = presetJSONDictionary["removeTags"] as? [String:String]
        if removeTags?.count > 0 {
            self.removeTags = removeTags;
        }
        
        let addTags = presetJSONDictionary["addTags"] as? [String:String]
        if addTags?.count > 0 {
            self.addTags = addTags;
        }
        
        if let geometry = presetJSONDictionary["geometry"] as? [String] {
            for string in geometry {
                self.geometry.append(GeometryType(rawValue: string)!)
            }
        }
        
        if let icon = presetJSONDictionary["icon"] as? String {
            self.icon = icon;
        }
        
        if let searchable = presetJSONDictionary["searchable"] as? Bool {
            self.searchable = searchable;
        }
        
        if let matchScore = presetJSONDictionary["matchScore"] as? Double {
            self.matchScore = matchScore;
        }
        
        if let terms = presetJSONDictionary["terms"] as? [String] {
            self.terms = terms;
        }
    }
}

public class PresetCategory {
    
    public var name = String()
    public var geometry = GeometryType.None
    public var iconName = String()
    public var members = [String]()
    
    init(categoryDictionary:Dictionary<String, AnyObject>) {
        if let name = categoryDictionary["name"] as? String {
            self.name = name;
        }
        
        if let geoString = categoryDictionary["geometry"] as? String {
            self.geometry = GeometryType(rawValue: geoString)!
        }
        
        if let iconString = categoryDictionary["icon"] as? String {
            self.iconName = iconString
        }
        
        if let membersArray = categoryDictionary["members"] as? Array<String> {
            self.members = membersArray
        }
    }
}