//
//  KeyboardTriggerBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 28/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardTriggerBehavior : Behavior {
    var keyboardFrame = CGRectZero
    var keyboardAnimationDuration:NSTimeInterval = 0.25
    var keyboardAnimationCurve = UIViewAnimationCurve.EaseOut
    var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle methods
    convenience init(notificationCenter nc: NSNotificationCenter) {
        self.init(frame: CGRectZero, notificationCenter: nc)
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, notificationCenter: NSNotificationCenter.defaultCenter())
    }
    
    init(frame: CGRect, notificationCenter nc: NSNotificationCenter) {
        notificationCenter = nc
        super.init(frame: frame)
        registerNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        unregisterNotifications()
    }
    
    
    //MARK: Notification and Listener methods
    @objc func keyboardWillShow(notification: NSNotification) {
        readNotificationInformation(notification)
        self.sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        readNotificationInformation(notification)
        self.sendActionsForControlEvents(UIControlEvents.EditingChanged)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        readNotificationInformation(notification)
        self.sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
    }
    
    //MARK: Internal methods
    private func registerNotifications() {
        notificationCenter.addObserver(
            self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: Selector("keyboardWillChange:"),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    private func unregisterNotifications() {
        notificationCenter.removeObserver(self)
    }
    
    private func readNotificationInformation(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            if let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboardFrameValue.CGRectValue()
            }
            
            if let keyboardAnimDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                keyboardAnimationDuration = keyboardAnimDurationValue.doubleValue
            }
            
            if let keyboardAnimationCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
                keyboardAnimationCurve = UIViewAnimationCurve(rawValue: keyboardAnimationCurveValue.integerValue)!
            }
        }
    }
    
}
