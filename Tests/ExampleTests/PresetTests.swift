//
//  PresetTests.swift
//  Example
//
//  Created by David Chiles on 2/9/17.
//  Copyright © 2017 David Chiles. All rights reserved.
//

import XCTest
@testable import iDSwift

class PresetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatch() {
        // No match
        XCTAssertEqual(Preset.matchScore(presetTags: ["foo": "bar"], tags: ["highway": "motorway"]), .NoScore)
        
        //Match with custom score
        XCTAssertEqual(Preset.matchScore(presetTags: ["highway": "motorway"], tags: ["highway": "motorway"], matchScore: 0.2), .Score(0.2))
        
        //Exact match
        XCTAssertEqual(Preset.matchScore(presetTags: ["highway": "motorway"], tags: ["highway": "motorway"]), .Score(1.0))
        
        // Two tags match
        XCTAssertEqual(Preset.matchScore(presetTags: ["highway": "service","service":"alley"], tags: ["highway": "service","service":"alley"]), .Score(2.0))
        
        // Match for key with any value
        XCTAssertEqual(Preset.matchScore(presetTags: ["building": "*"], tags: ["building": "yep"]), .Score(0.5))
    }
    
}
