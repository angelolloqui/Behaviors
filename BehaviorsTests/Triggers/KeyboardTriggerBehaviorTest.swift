//
//  KeyboardTriggerBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 29/04/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation

import UIKit
import XCTest

class KeyboardTriggerBehaviorTest: XCTestCase {
    var notificationCenter: MockNotificationCenter!
    var behavior: KeyboardTriggerBehavior!

    override func setUp() {
        super.setUp()
        
        //Notification center
        notificationCenter = MockNotificationCenter()
        
        //Behavior
        behavior = KeyboardTriggerBehavior(notificationCenter: notificationCenter)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testBehaviourRegistersKeyboardNotificationsForFrameChanges() {
        XCTAssert(notificationCenter.observers.count == 3, "Should have registered observers")
        let validObservers = notificationCenter.observers.filter { (info : MockNotificationCenter.ObserverInfo) -> Bool in
            return info.observer as! Behavior == self.behavior && info.name == UIKeyboardWillChangeFrameNotification
        }
        XCTAssert(validObservers.count > 0, "No observers registered for expected names (UIKeyboardWillChangeFrameNotification)")
    }
    
    func testBehaviourUnRegistersKeyboardNotificationsForFrameChanges() {
        weak var weakBehavior = behavior
        let count = notificationCenter.observers.count
        XCTAssert(count > 0, "Should have registered observers")
        behavior = nil
        XCTAssertNil(weakBehavior, "Should have released behavior")
        XCTAssert(notificationCenter.observers.count < count, "Should have unregistered observers")
    }
    
    func testKeyboardWillShowActionEditingDidBegin() {
        let behavior = MockKeyboardTriggerBehavior(notificationCenter: notificationCenter)
        XCTAssert(behavior.events.count == 0, "Should have no events yet")
        
        notificationCenter.postNotificationName(UIKeyboardWillShowNotification, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.postNotificationName(UIKeyboardDidShowNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardWillChangeFrameNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardWillHideNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardDidHideNotification, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.EditingDidBegin }.count == 1, "Should have received no extra events")
    }
    

    func testKeyboardSizeChangeFiresActionEditingChanged() {
        let behavior = MockKeyboardTriggerBehavior(notificationCenter: notificationCenter)
        XCTAssert(behavior.events.count == 0, "Should have no events yet")
        
        notificationCenter.postNotificationName(UIKeyboardWillChangeFrameNotification, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.postNotificationName(UIKeyboardWillShowNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardDidShowNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardWillHideNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardDidHideNotification, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.EditingChanged }.count == 1, "Should have received no extra events")
    }
    
    
    func testKeyboardHideActionEditingDidEnd() {
        let behavior = MockKeyboardTriggerBehavior(notificationCenter: notificationCenter)
        XCTAssert(behavior.events.count == 0, "Should have no events yet")
        
        notificationCenter.postNotificationName(UIKeyboardWillHideNotification, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.postNotificationName(UIKeyboardWillShowNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardDidShowNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardWillChangeFrameNotification, object: nil, userInfo:[:])
        notificationCenter.postNotificationName(UIKeyboardDidHideNotification, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.EditingDidEnd }.count == 1, "Should have received no extra events")
    }
    
    
}

class MockKeyboardTriggerBehavior: KeyboardTriggerBehavior {
    var events: [UIControlEvents] = []
    
    override func sendActionsForControlEvents(controlEvents: UIControlEvents) {
        events.append(controlEvents)
        super.sendActionsForControlEvents(controlEvents)
    }
}

