//
//  BehaviorsTests.swift
//  BehaviorsTests
//
//  Created by Angel Garcia on 09/04/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import UIKit
import XCTest

class BehaviorsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBehaviorLifetimeDependsOnOwner() {
        
        var object: NSObject? = NSObject()
        var behavior: Behavior? = Behavior()
        behavior?.owner = object

        XCTAssert(behavior != nil, "Behavior should not be released yet")
        XCTAssert(behavior?.owner as! NSObject? == object, "Behavior owner is wrong")

        weak var weakBehavior = behavior
        behavior = nil
        XCTAssert(weakBehavior != nil, "Behavior should not be released yet")
        object = nil
        XCTAssert(weakBehavior == nil, "Behavior should now be released as there is no owner assigned")
    }
    
    
}
