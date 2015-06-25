//
//  Deprecated.swift
//  Pods
//
//  Created by David Chiles on 6/23/15.
//
//

import Foundation

public class DeprecatedTag {
    
    public var oldTags:[String:String]
    public var newTags:[String:String]
    
    init(oldTags:[String:String], newTags:[String:String]) {
        self.oldTags = oldTags
        self.newTags = newTags
    }
}