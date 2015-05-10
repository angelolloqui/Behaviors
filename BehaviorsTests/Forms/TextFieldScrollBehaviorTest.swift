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
    var scrollView: MockScrollView!
    var behavior: TextFieldScrollBehavior!
    var notificationCenter: MockNotificationCenter!

    override func setUp() {
        super.setUp()
        
        //Views
        scrollView = MockScrollView()
        textFields = [
            MockTextField(),
            MockTextField(),
            MockTextField()
        ]
        var posY = 0
        for textField in textFields {
            posY += 200
            textField.frame = CGRect(x: 0, y: posY, width: 100, height: 50)
            scrollView.addSubview(textField)
        }
        
        //Notification center
        notificationCenter = MockNotificationCenter()
        
        //Behavior
        behavior = TextFieldScrollBehavior(notificationCenter: notificationCenter)
        behavior.textFields = textFields
        behavior.scrollView = scrollView
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


    func testTextFieldBeginAndEndEditingFiresScrolling() {
        let textField = textFields[1]
        let mockBehavior = MockTextFieldScrollBehavior()
        mockBehavior.textFields = textFields
        mockBehavior.scrollView = scrollView
        XCTAssert(mockBehavior.autoScrollCount == 0, "No autoscroll should have been performed yet")
        textField.sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
        XCTAssert(mockBehavior.autoScrollCount == 1, "Autoscroll should have been performed on DidBegin")
        textField.sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
        XCTAssert(mockBehavior.autoScrollCount == 2, "Autoscroll should have been performed on DidEnd")
    }
    
    func testScrollContentInsetSetProperly() {
        XCTFail("Not implemented")
    }

    func testScrollContentOffsetSetProperly() {
        XCTFail("Not implemented")
    }
    
    
    func testBehaviourRegistersKeyboardNotificationsForFrameChanges() {
        XCTAssert(notificationCenter.observers.count > 0, "Should have registered observers")
        let validObservers = notificationCenter.observers.filter { (info : MockNotificationCenter.ObserverInfo) -> Bool in
            return info.observer as! Behavior == self.behavior && info.name == UIKeyboardWillChangeFrameNotification
        }
        XCTAssert(validObservers.count > 0, "No observers registered for expected names (UIKeyboardWillChangeFrameNotification)")
    }
    
    func testKeyboardSizeChangeChangesScrollInsetAndOffset() {
        XCTFail("Not implemented")
    }

}

//MARK: Mock objects
class MockTextField : UITextField {
    var firstResponder = false
    override func isFirstResponder() -> Bool {
        return firstResponder
    }
}

class MockScrollView : UIScrollView {
    
}

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

class MockTextFieldScrollBehavior : TextFieldScrollBehavior {
    var autoScrollCount = 0
    
    override func autoScroll(#animated: Bool) {
        autoScrollCount++
        super.autoScroll(animated: animated)
    }
}

