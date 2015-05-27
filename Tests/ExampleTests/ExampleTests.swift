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
    
    func testExample() {
        var numberOfPresets = 0
        var expectation = self.expectationWithDescription("testExample")
        
        Parser.parseAllPresets(foundPreset: { (preset) -> Void in
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
            XCTAssertEqual(numberOfPresets, 581, "Did not find all presets")
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
