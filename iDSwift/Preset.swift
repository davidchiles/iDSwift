//
//  Preset.swift
//  iDSwiftTest
//
//  Created by David Chiles on 5/22/15.
//  Copyright (c) 2015 David Chiles. All rights reserved.
//

import Foundation

public typealias TagDictionary = [String:String]

public enum GeometryType : String, CustomStringConvertible {
    case Point    = "point"
    case Vertex   = "vertex"
    case Line     = "line"
    case Area     = "area"
    case Relation = "relation"
    
    public var description: String {
        return self.rawValue
    }
}

public enum FieldType: String, CustomStringConvertible {
    case Combo        = "combo"
    case MultiCombo   = "multiCombo"
    case NetworkCombo = "networkCombo"
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
    case Email        = "email"
    case Cycleway     = "cycleway"
    
    public var description: String {
        return self.rawValue
    }
}



public class Preset {
    
    public let geometry:[GeometryType]
    public let tags:TagDictionary
    public let name:String
    public private(set) var fields:[String]?
    
    public private(set) var addTags: TagDictionary?
    public private(set) var removeTags: TagDictionary?
    
    //Default Icon from maki
    public private(set) var icon = "marker-stroked"
    
    public private(set) var searchable = true
    
    public private(set) var matchScore:Double = 1;
    
    public private(set) var terms:[String]?
    
    init(presetJSONDictionary: Dictionary<String,AnyObject>) throws {
        
        guard let name = presetJSONDictionary["name"] as? String,
            let tags = presetJSONDictionary["tags"] as? TagDictionary,
            let geometry = presetJSONDictionary["geometry"] as? [String] else {
                
            throw ParseError.InvalidJSONStructure
        }
        
        self.name = name
        self.tags = tags
        
        self.geometry = geometry.map({ (geometryString) -> GeometryType in
            return GeometryType(rawValue: geometryString)!
        })
        
        if let fields = presetJSONDictionary["fields"] as? [String] {
            self.fields = fields
        }
        
        if let removeTags = presetJSONDictionary["removeTags"] as? TagDictionary, removeTags.count > 0 {
            self.removeTags = removeTags
        }
        
        if let addTags = presetJSONDictionary["addTags"] as? TagDictionary, addTags.count > 0 {
            self.addTags = addTags
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

public enum PresetScore: Equatable {
    case Score(Double)
    case NoScore
    
    public static func ==(lhs: PresetScore, rhs: PresetScore) -> Bool {
        switch (lhs, rhs) {
        case (.NoScore, .NoScore):
            return true
        case (let .Score(score1), let .Score(score2)):
            return score1 == score2
        default:
            return false
        }
    }
}

public extension Preset {
    
    
    public class func matchScore(presetTags:TagDictionary,tags:TagDictionary,matchScore:Double = 1) -> PresetScore {
        var score:Double = 0
        for (key, value) in presetTags {
            if (value == tags[key]) {
                score += matchScore
            } else if (value == "*" && tags[key] != nil) {
                score += matchScore / 2.0
            } else {
                return .NoScore
            }
        }
        return .Score(score)
    }
}

public class PresetCategory {
    
    public let name:String
    public let geometry:GeometryType
    public let iconName:String
    public let members:[String]
    
    init(categoryDictionary:Dictionary<String, AnyObject>) throws {
        guard let name = categoryDictionary["name"] as? String,
            let geoString = categoryDictionary["geometry"] as? String,
            let geometry =  GeometryType(rawValue: geoString),
            let iconString = categoryDictionary["icon"] as? String,
            let membersArray = categoryDictionary["members"] as? Array<String> else {
                
            throw ParseError.InvalidJSONStructure
        }
        
        self.name = name
        self.geometry = geometry
        self.iconName = iconString
        self.members = membersArray
    }
}

public enum Keys {
    case Single(String)
    case Mutiple([String])
}

public enum Reference {
    case Relation(String)
    case Key(String)
}

//Used with: combo, typeCombo, multiCombo, radio, check
public enum StringOptions {
    case Simple(String)
    case Complex(ComplexStringsOptions)
}

public struct FieldStrings {
    let types:[String:String]?
    let options:[String:StringOptions]
}

//Used with: access, cycleway
public struct ComplexStringsOptions {
    let title:String
    let description:String
}
public class PresetField {
    
    public let type:FieldType
    public let label:String
    
    public private(set) var keys: Keys?
    public private(set) var reference:Reference?
    public private(set) var universal = false
    public private(set) var snake_case = true
    public private(set) var placeholder: String?
    public private(set) var iconName: String?
    public private(set) var `default`:String?
    public private(set) var options:[String]?
    public private(set) var strings:[String:Any]?
    
    init(fieldDictionary:Dictionary<String, AnyObject>) throws {
        
        guard let labelString = fieldDictionary["label"] as? String, let typeString = fieldDictionary["type"] as? String, let type = FieldType(rawValue: typeString) else {
            throw ParseError.InvalidJSONStructure
        }
        
        self.type = type
        self.label = labelString
        
        
        if let key = fieldDictionary["key"] as? String {
            self.keys = .Single(key)
        } else if let keys = fieldDictionary["keys"] as? [String] {
            self.keys = .Mutiple(keys)
        }
        
        if let universal = fieldDictionary["universal"] as? Bool {
            self.universal = universal
        }
        
        self.placeholder = fieldDictionary["placeholder"] as? String
        self.iconName = fieldDictionary["icon"] as? String
        
        if let reference = fieldDictionary["reference"] as? Dictionary<String,String> {
            if let value = reference["key"] {
                self.reference = .Key(value)
            } else if let rtype = reference["rtype"] {
                self.reference = .Relation(rtype)
            }
        }
        
        if let options = fieldDictionary["options"] as? [String] {
            self.options = options
        }
    
        if let strings = fieldDictionary["strings"] as? [String:Any] {
             self.strings = strings
        }
        
    }
}
