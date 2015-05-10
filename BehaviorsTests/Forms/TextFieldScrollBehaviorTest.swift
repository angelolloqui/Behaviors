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
    var textFields: [MockTextField]!
    var behavior: TextFieldScrollBehavior!
    var notificationCenter: MockNotificationCenter!

    override func setUp() {
        super.setUp()
        textFields = [
            MockTextField(),
            MockTextField(),
            MockTextField()
        ]
        notificationCenter = MockNotificationCenter()
        behavior = TextFieldScrollBehavior(notificationCenter: notificationCenter)
        behavior.textFields = textFields
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBehaviorRegistersTargetBeginAndEndEditingOnTextFields() {
        //Check targets
        for field in textFields {
            let beginTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidBegin)
            XCTAssert(beginTargets?.count == 1, "Expected 1 target for EditingDidBegin")
            let endTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidEnd)
            XCTAssert(endTargets?.count == 1, "Expected 1 target for EditingDidEnd")
        }
    }
    

    func testBehaviorUpdatesTargetsOnTextFieldChanges() {
        let newTextField = MockTextField()
        let removedTextFields = [
            textFields[0],
            textFields[2]
        ]
        let newTextFields = [
            textFields[1],
            newTextField
        ]
        behavior.textFields = newTextFields
        
        //Check new textfields for registered targets
        for field in newTextFields {
            let beginTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidBegin)
            XCTAssert(beginTargets?.count == 1, "Expected 1 target for EditingDidBegin")
            let endTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidEnd)
            XCTAssert(endTargets?.count == 1, "Expected 1 target for EditingDidEnd")
        }
        
        //Check removed textfields for unregistration
        for field in removedTextFields {
            let beginTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidBegin)
            XCTAssert(beginTargets == nil, "Expected no target for EditingDidBegin")
            let endTargets = field.actionsForTarget(behavior, forControlEvent: UIControlEvents.EditingDidEnd)
            XCTAssert(endTargets == nil, "Expected no target for EditingDidEnd")
        }
    }


    func testBehaviourRegistersKeyboardNotifications() {
        XCTAssert(notificationCenter.observers.count > 0, "Should have registered observers")
        let validObservers = notificationCenter.observers.filter { (info : MockNotificationCenter.ObserverInfo) -> Bool in
            return info.observer as! Behavior == self.behavior && info.name == UIKeyboardWillChangeFrameNotification
        }
        XCTAssert(validObservers.count > 0, "No observers registered for expected names (UIKeyboardWillChangeFrameNotification)")
        
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
    
    func testKeyboardSizeChangeChangesScrollInsetAndOffset() {
        XCTFail("Not implemented")
    }

}

//MARK: Mock objects
class MockTextField : UITextField {}


class MockNotificationCenter : NSNotificationCenter {
    struct ObserverInfo : Equatable {
        let observer: AnyObject
        let selector: Selector
        let name: String
    }
    
    var observers = [ObserverInfo]()
    
    override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
        let observerInfo = ObserverInfo(observer: observer, selector: aSelector, name: aName!)
        observers.append(observerInfo)
    }
}

func ==(lhs: MockNotificationCenter.ObserverInfo, rhs: MockNotificationCenter.ObserverInfo) -> Bool {
    if  let observer1 = lhs.observer as? NSObject,
        let observer2 = rhs.observer as? NSObject {
            return observer1 == observer2 &&
                lhs.selector == rhs.selector &&
                lhs.name == rhs.name
    }
    return false
}


