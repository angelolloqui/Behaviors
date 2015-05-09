//
//  KeyboardScrollBehaviorTest.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import UIKit
import XCTest

class TextFieldScrollBehaviorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanRegisterMultipleTextfield() {
        XCTFail("Not implemented")
    }
    
    func testBehaviorRegistersBeginEditingOnTextFields() {
        XCTFail("Not implemented")
    }

    func testBehaviorRegistersEndEditingOnTextFields() {
        XCTFail("Not implemented")
    }

    func testBehaviourRegistersKeyboardNotifications() {
        let notificationCenter = MockNotificationCenter()
        XCTAssert(notificationCenter.observers.count == 0, "Should not have registered observers")
        var behavior  = TextFieldScrollBehavior(notificationCenter: notificationCenter)
        XCTAssert(notificationCenter.observers.count > 0, "Should have registered observers")
//        let validObservers = notificationCenter.observers.filter { (info : MockNotificationCenter.ObserverInfo) -> Bool in
//            return info.observer == behavior && info.name! == UIKeyboardWillChangeFrameNotification
//        }
//        XCTAssert(validObservers.count > 0, "No observers registered for expected names (UIKeyboardWillChangeFrameNotification)")
        
    }

    func testKeyboardNotificationFiresScrollingToFocusTextField() {
        XCTFail("Not implemented")
    }

    func testTextFieldFocusFiresScrolling() {
        XCTFail("Not implemented")
    }

    func testScrollContentInsetSetProperly() {
        XCTFail("Not implemented")
    }

    func testScrollContentOffsetSetProperly() {
        XCTFail("Not implemented")
    }
    
    class MockNotificationCenter : NSNotificationCenter {
        struct ObserverInfo {
            weak var observer: AnyObject?
            let selector: Selector
            let name: String?
            let object: AnyObject?
        }
        
        var observers = [ObserverInfo]()
        
        override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
            let observerInfo = ObserverInfo(observer: observer, selector: aSelector, name: aName, object: anObject)
            observers.append(observerInfo)
        }
    }

}
