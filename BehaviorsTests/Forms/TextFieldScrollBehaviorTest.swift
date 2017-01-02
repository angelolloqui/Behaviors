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
    var window: UIWindow!
    var textFields: [MockTextField]!
    var scrollView: UIScrollView!
    var behavior: TextFieldScrollBehavior!
    var notificationCenter: MockNotificationCenter!

    override func setUp() {
        super.setUp()
        
        //Views
        window = UIWindow(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 500)))
        
        scrollView = UIScrollView(frame: window.bounds)
        window.addSubview(scrollView)
        
        textFields = [
            MockTextField(frame: CGRect(x: 0, y: 100, width: 300, height: 50)),
            MockTextField(frame: CGRect(x: 0, y: 250, width: 300, height: 50)),
            MockTextField(frame: CGRect(x: 0, y: 400, width: 300, height: 50))
        ]
        for textField in textFields {
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
    
    func testBehaviourRegistersKeyboardNotificationsForFrameChanges() {
        XCTAssert(notificationCenter.observers.count > 0, "Should have registered observers")
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
    
    func testKeyboardSizeChangeFiresAutoScroll() {
        let behavior = MockTextFieldScrollBehavior(notificationCenter: notificationCenter)
        let count = behavior.autoScrollCount
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, userInfo:[:])
        XCTAssert(behavior.autoScrollCount > count, "Should have called autoscroll")
    }
    
    
    func testScrollContentInsetSetProperlyWhenFirstResponder() {
        XCTAssert(scrollView.contentInset.bottom == 0)
        textFields.first?.firstResponder = true
        behavior.keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 100)
        behavior.offsetEnabled = false
        behavior.insetEnabled = true
        behavior.autoScroll()
        XCTAssert(behavior.appliedInsetSize.height == 100)
        XCTAssert(scrollView.contentInset.bottom == 100)
    }

    
    func testScrollContentInsetResetWhenNoFirstResponder() {
        scrollView.contentInset.bottom = 150
        behavior.appliedInsetSize = CGSize(width: 0, height: 100)
        behavior.offsetEnabled = false
        behavior.insetEnabled = true
        behavior.autoScroll()
        XCTAssert(scrollView.contentInset.bottom == 50)
    }

    
    func testKeyboardHideClearsContentInsetToOriginal() {
        scrollView.contentInset.bottom = 150
        behavior.appliedInsetSize = CGSize(width: 0, height: 100)
        behavior.offsetEnabled = false
        behavior.insetEnabled = true
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil, userInfo:[:])
        XCTAssert(scrollView.contentInset.bottom == 50)
    }

    func testScrollContentOffsetNotChangedWhenFieldVisible() {
        scrollView.contentOffset = CGPoint.zero
        textFields.first?.firstResponder = true
        behavior.keyboardFrame = CGRect(x: 0, y: 300, width: 300, height: 200)
        behavior.offsetEnabled = true
        behavior.insetEnabled = false
        behavior.autoScroll()
        XCTAssert(scrollView.contentOffset.y == 0)
    }

    func testScrollContentOffsetSetWhenFieldNotVisible() {
        scrollView.contentOffset = CGPoint.zero
        textFields.last?.firstResponder = true
        behavior.keyboardFrame = CGRect(x: 0, y: 300, width: 300, height: 200)
        behavior.offsetEnabled = true
        behavior.insetEnabled = false
        behavior.bottomMargin = 20
        behavior.autoScroll()
        XCTAssert(scrollView.contentOffset.y == 170)
    }
}

// MARK: Mock objects
class MockTextField : UITextField {
    var firstResponder = false
    
    override open var isFirstResponder: Bool {
        return firstResponder
    }
}

class MockTextFieldScrollBehavior : TextFieldScrollBehavior {
    var autoScrollCount = 0
    
    override func autoScroll(_ animated: Bool = true) {
        autoScrollCount = autoScrollCount + 1
        super.autoScroll(animated)
    }
    
}

