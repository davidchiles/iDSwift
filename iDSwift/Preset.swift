//
//  Preset.swift
//  iDSwiftTest
//
//  Created by David Chiles on 5/22/15.
//  Copyright (c) 2015 David Chiles. All rights reserved.
//

import Foundation

enum GeometryType : String {
    case None   = ""
    case Point  = "point"
    case Vertex = "vertex"
    case Line   = "line"
    case Area   = "area"
}

class Preset {
    
    var geometry = [GeometryType]()
    
    var tags = [String:String]()
    
    var fields = [String]()
    
    var name = String()
    
    var icon = String()
    
    var searchable = true
    
    var matchScore = 1;
    
    init(presetJSONDictionary: Dictionary<String,AnyObject>) {
        if let fields = presetJSONDictionary["fields"] as? [String] {
            self.fields = fields
        }
        
        if let tags = presetJSONDictionary["tags"] as? [String:String] {
            self.tags = tags;
        }
        
        if let geometry = presetJSONDictionary["geometry"] as? [String] {
            
        }
    }
    
}