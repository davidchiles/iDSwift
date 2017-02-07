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
    
    let expectedPresetCount = 2144
    let expectedDeprecatedCount = 13
    let expectedCategoryCount = 14
    let expectedPresetFieldsCount = 218
    let expectedDiscardedCount = 42
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPresetsParser() {
        let presets = try! Parser.parseAllPresets()
        
        XCTAssertEqual(presets.count, expectedPresetCount,"Find all presets")
        presets.forEach { (preset) in
            XCTAssertGreaterThan(preset.name.characters.count, 0, "No name")
            XCTAssertGreaterThan(preset.geometry.count, 0, "No Geometry \(preset.name)")
            XCTAssertGreaterThan(preset.icon.characters.count, 0, "No Icon \(preset.name)")
        }
    }
    
    func testDeprecatedTagsParser() {
        
        let deprecatedTags = try! Parser.parseAllDeprecatedTags()
        
        XCTAssertEqual(deprecatedTags.count, expectedDeprecatedCount,"Find all deprecated")
        deprecatedTags.forEach { (deprecatedTag) in
            XCTAssertGreaterThan(deprecatedTag.oldTags.count, 0, "No old Tags")
            XCTAssertGreaterThan(deprecatedTag.newTags.count, 0, "No new Tags")
        }
    }
    
    func testPresetCategoryParser() {
        
        let categories = try! Parser.parseAllPresetCategories()
        
        XCTAssertEqual(categories.count, expectedCategoryCount,"Find all categories")
        
        categories.forEach { (category) in
            XCTAssertGreaterThan(category.iconName.characters.count, 0, "No icon name")
            XCTAssertGreaterThan(category.name.characters.count, 0, "No name")
            XCTAssertGreaterThan(category.members.count, 0, "No members found")
        }
    }
    
    func testPresetFieldParser() {
    
        let fields = try! Parser.parseAllPresetFields()
        
        XCTAssertEqual(fields.count, expectedPresetFieldsCount, "Found \(fields.count) fields")
        XCTAssertEqual(fields.filter { $0.universal }.count, 13, "Universal fields")
        XCTAssertEqual(fields.filter { $0.iconName != nil }.count, 10, "Icons")
        XCTAssertEqual(fields.filter { $0.placeholder != nil }.count, 39, "Placeholders")
        
        fields.forEach { (field) in
            XCTAssertTrue(field.label.characters.count > 0, "No label")
        }
    }
    
    func testDiscardedTags() {
        let discarded = try! Parser.parseDiscarded()
        
        XCTAssertEqual(discarded.count, expectedDiscardedCount)
    }
}
