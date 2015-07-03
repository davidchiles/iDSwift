//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by David Chiles on 5/22/15.
//  Copyright (c) 2015 David Chiles. All rights reserved.
//

import UIKit
import XCTest
import iDSwift

class ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPresetsParser() {
        var numberOfPresets = 0
        var expectation = self.expectationWithDescription("testExample")
        
        PresetParser.parseAllPresets(foundPreset: { (preset) -> Void in
            numberOfPresets = numberOfPresets + 1
            var nameLength = count(preset.name)
            var geometryLength = count(preset.geometry)
            var iconLength = count(preset.icon)
            
            XCTAssertGreaterThan(nameLength, 0, "No name")
            XCTAssertGreaterThan(geometryLength, 0, "No Geometry \(preset.name)")
            XCTAssertGreaterThan(iconLength, 0, "No Icon \(preset.name)")
        }, completion: { () -> Void in
            expectation.fulfill()
        })
        
        var error: NSError
        self.waitForExpectationsWithTimeout(500, handler: { (error) -> Void in
            XCTAssertEqual(numberOfPresets, 2022, "Did not find all presets")
        })
    }
    
    func testDeprecatedTagsParser() {
        var numberOfDeprecatedTags = 0
        var expectation = self.expectationWithDescription("deprecatedTags")
        
        DeprecatedTagParser.parseAllDeprecatedTags(foundDeprecatedTag: { (deprecatedTag) -> Void in
            
            numberOfDeprecatedTags = numberOfDeprecatedTags + 1
            var oldTagCount = count(deprecatedTag.oldTags)
            var newTagCount = count(deprecatedTag.newTags)
            XCTAssertGreaterThan(oldTagCount, 0, "No old Tags")
            XCTAssertGreaterThan(newTagCount, 0, "No new Tags")
            
        }) { () -> Void in
            expectation.fulfill()
        }
        
        var error: NSError
        self.waitForExpectationsWithTimeout(4, handler: { (error) -> Void in
            XCTAssertEqual(numberOfDeprecatedTags, 13, "Only found \(numberOfDeprecatedTags) deprecated tags")
        })
    }
    
    func testPresetCategoryParser() {
        var numberOfCategories = 0
        var expectation = self.expectationWithDescription("Categories")
        
        PresetCategoriesParser.parseAllPresetCategories(foundPresetCategory: { (category) -> Void in
            numberOfCategories = numberOfCategories + 1
            var countOfMembers = count(category.members)
            var nameLength = count(category.name)
            var iconLength = count(category.iconName)
            var hasGeometry = category.geometry != .None
            
            XCTAssertTrue(hasGeometry, "Has no geometry")
            XCTAssertGreaterThan(iconLength, 0, "No icon name")
            XCTAssertGreaterThan(nameLength, 0, "No name")
            XCTAssertGreaterThan(countOfMembers, 0, "No members found")
            
        }) { () -> Void in
            expectation.fulfill()
        }
        
        var error: NSError
        self.waitForExpectationsWithTimeout(5, handler: { (error) -> Void in
            XCTAssertEqual(numberOfCategories, 10, "Only found \(numberOfCategories) categories")
        })
    }
    
    func testPresetFieldParser() {
        
        var numberOfFields = 0
        var numberOfUniversal = 0
        var numberOfPlaceHolder = 0
        var numberOfIcon = 0
        var expectation = self.expectationWithDescription("Fields")
        
        var excludeKeySet = Set(["Turn Restrictions"])
        
        PresetFieldsParser.parseAllPresetFields(foundPresetField: { (field) -> Void in
            
            numberOfFields = numberOfFields + 1
            
            var hasType = field.type != .None
            var hasLabel = count(field.label) > 0
            
            var hasKey = false
            if let key = field.key {
                hasKey = count(key) > 0
            }
            
            if let keys = field.keys {
                hasKey = count(keys) > 0
            }
            
            if field.universal {
                numberOfUniversal = numberOfUniversal + 1
            }
            
            if let placeholder = field.placeholder {
                numberOfPlaceHolder = numberOfPlaceHolder + 1
            }
            
            if let icon = field.iconName {
                numberOfIcon = numberOfIcon + 1
            }
            
            XCTAssertTrue(hasLabel, "No label")
            XCTAssertTrue(hasType, "Field does not have type")
            
            if !excludeKeySet.contains(field.label) {
                XCTAssertTrue(hasKey, "Field: \(field.label) does not have a key(s)")
            }
            
            
        }) { () -> Void in
            expectation.fulfill()
        }
        
        var error: NSError
        self.waitForExpectationsWithTimeout(500, handler: { (error) -> Void in
            XCTAssertEqual(numberOfFields, 167, "Only found \(numberOfFields) fields")
            XCTAssertEqual(numberOfUniversal, 8, "Only found \(numberOfUniversal) universal fields")
            XCTAssertEqual(numberOfIcon, 9, "Only found \(numberOfIcon) icons")
            XCTAssertEqual(numberOfPlaceHolder, 31, "Only found \(numberOfPlaceHolder) placeholders")
        })
    }
}
