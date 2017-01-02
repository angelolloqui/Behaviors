//
//  KeyboardTriggerBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 28/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class KeyboardTriggerBehavior : Behavior {
    var keyboardFrame = CGRect.zero
    var keyboardAnimationDuration:TimeInterval = 0.25
    var keyboardAnimationCurve = UIViewAnimationCurve.easeOut
    var notificationCenter: NotificationCenter = NotificationCenter.default
    
    
    // MARK: Lifecycle methods
    convenience init(notificationCenter nc: NotificationCenter) {
        self.init(frame: CGRect.zero, notificationCenter: nc)
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, notificationCenter: NotificationCenter.default)
    }
    
    init(frame: CGRect, notificationCenter nc: NotificationCenter) {
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
    
    
    // MARK: Notification and Listener methods
    @objc func keyboardWillShow(_ notification: Notification) {
        readNotificationInformation(notification)
        self.sendActions(for: UIControlEvents.editingDidBegin)
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        readNotificationInformation(notification)
        self.sendActions(for: UIControlEvents.editingChanged)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        readNotificationInformation(notification)
        self.sendActions(for: UIControlEvents.editingDidEnd)
    }
    
    // MARK: Internal methods
    fileprivate func registerNotifications() {
        notificationCenter.addObserver(
            self,
            selector: #selector(KeyboardTriggerBehavior.keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(KeyboardTriggerBehavior.keyboardWillChange(_:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(KeyboardTriggerBehavior.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    fileprivate func unregisterNotifications() {
        notificationCenter.removeObserver(self)
    }
    
    fileprivate func readNotificationInformation(_ notification: Notification) {
        if  let userInfo = notification.userInfo {
            if let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboardFrameValue.cgRectValue
            }
            
            if let keyboardAnimDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                keyboardAnimationDuration = keyboardAnimDurationValue.doubleValue
            }
            
            if let keyboardAnimationCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
                keyboardAnimationCurve = UIViewAnimationCurve(rawValue: keyboardAnimationCurveValue.intValue)!
            }
        }
    }
   
}
