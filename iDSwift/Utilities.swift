//
//  Utilities.swift
//  Pods
//
//  Created by David Chiles on 7/3/15.
//
//

import Foundation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}