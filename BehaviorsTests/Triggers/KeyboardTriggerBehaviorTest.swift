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
            return info.observer as! Behavior == self.behavior && info.name == NSNotification.Name.UIKeyboardWillChangeFrame.rawValue
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
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidShow, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidHide, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.editingDidBegin }.count == 1, "Should have received no extra events")
    }
    

    func testKeyboardSizeChangeFiresActionEditingChanged() {
        let behavior = MockKeyboardTriggerBehavior(notificationCenter: notificationCenter)
        XCTAssert(behavior.events.count == 0, "Should have no events yet")
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidShow, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidHide, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.editingChanged }.count == 1, "Should have received no extra events")
    }
    
    
    func testKeyboardHideActionEditingDidEnd() {
        let behavior = MockKeyboardTriggerBehavior(notificationCenter: notificationCenter)
        XCTAssert(behavior.events.count == 0, "Should have no events yet")
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo:[:])
        
        XCTAssert(behavior.events.count == 1, "Should have received an event")
        
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidShow, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, userInfo:[:])
        notificationCenter.post(name: NSNotification.Name.UIKeyboardDidHide, object: nil, userInfo:[:])
        XCTAssert(behavior.events.filter { $0 == UIControlEvents.editingDidEnd }.count == 1, "Should have received no extra events")
    }
    
    
}

class MockKeyboardTriggerBehavior: KeyboardTriggerBehavior {
    var events: [UIControlEvents] = []
    
    override func sendActions(for controlEvents: UIControlEvents) {
        events.append(controlEvents)
        super.sendActions(for: controlEvents)
    }
}

