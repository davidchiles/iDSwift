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

public enum FieldType: String, Printable {
    case None         = ""
    case Combo        = "combo"
    case Radio        = "radio"
    case Text         = "text"
    case Check        = "check"
    case URL          = "url"
    case Telephone    = "tel"
    case Access       = "access"
    case Number       = "number"
    case Wikipedia    = "wikipedia"
    case TypeCombo    = "typeCombo"
    case Address      = "address"
    case Restrictions = "restrictions"
    case TextArea     = "textarea"
    case Localized    = "localized"
    case MaxSpeed     = "maxspeed"
    
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

public class PresetField {
    
    public var type = FieldType.None
    public var key: String?
    public var keys: [String]?
    public var label = String()
    public var universal = false
    public var placeholder: String?
    public var iconName: String?
    public var options: [String]?
    var strings: [String: String]?
    
    init(fieldDictionary:Dictionary<String, AnyObject>) {
        
        if let labelString = fieldDictionary["label"] as? String {
            self.label = labelString
        }
        
        if let typeString = fieldDictionary["type"] as? String {
            self.type = FieldType(rawValue: typeString)!
        }
        
        if let key = fieldDictionary["key"] as? String {
            self.key = key
        }
        
        if let keys = fieldDictionary["keys"] as? [String] {
            self.keys = keys
        }
        
        if let universal = fieldDictionary["universal"] as? Bool {
            self.universal = universal
        }
        
        self.placeholder = fieldDictionary["placeholder"] as? String
        self.iconName = fieldDictionary["icon"] as? String
        
        if let options = fieldDictionary["options"] as? [String] {
            self.options = options
        }
        
        if let strings = fieldDictionary["strings"] as? [String:[String: String]] {
            self.strings = strings["options"]
            
            if self.options == nil {
                self.options = self.strings?.keys.array
            }
            
            if let pStrings = strings["placeholders"] {
                if var tempStrings = self.strings {
                    tempStrings += pStrings
                } else {
                    self.strings = pStrings
                }
            }
        }
        
        if self.type == .Access {
            if let accessStrings = fieldDictionary["strings"] as? [String: AnyObject] {
                if let typeStrings = accessStrings["types"] as? [String: String] {
                    self.strings = typeStrings
                }
                
                if let optionsStrings = accessStrings["options"] as? [String: [String: String]] {
                    for (key, value) in optionsStrings {
                        if let title = value["title"] {
                            self.strings?.updateValue(title, forKey: key)
                        }
                    }
                }
            }

        }
        
        
    }
    
    public func stringForValue(value:String) -> String? {
        if let strings = self.strings {
            return strings[value]
        }
        return nil
    }
    
}