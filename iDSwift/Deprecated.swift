//
//  Deprecated.swift
//  Pods
//
//  Created by David Chiles on 6/23/15.
//
//

import Foundation

open class DeprecatedTag {
    
    open var oldTags:[String:String]
    open var newTags:[String:String]
    
    init(oldTags:[String:String], newTags:[String:String]) {
        self.oldTags = oldTags
        self.newTags = newTags
    }
}
