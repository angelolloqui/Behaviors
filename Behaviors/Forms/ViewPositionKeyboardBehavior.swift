//
//  ViewPositionScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 15/01/16.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class ViewPositionKeyboardBehavior : Behavior {
    
    @IBOutlet public weak var constraint: NSLayoutConstraint! {
        didSet {
            originConstraintConstant = constraint.constant
        }
    }
    @IBOutlet public weak var view: UIView!

    var originConstraintConstant : CGFloat = 0
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
    
    func readNotificationInfo(notification: NSNotification) {
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
    
    func keyboardWillChange(notification: NSNotification) {
        readNotificationInfo(notification)
        if let viewFrameInWindow = view.window?.convertRect(view.bounds, fromView:view) {
            
            let distance = CGRectGetMaxY(viewFrameInWindow) - CGRectGetMinY(keyboardFrame)
            
            if distance > 0 {
                constraint.constant = originConstraintConstant + distance
                let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
                    self.view.window?.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        readNotificationInfo(notification)
        
        constraint.constant = originConstraintConstant
        let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
        UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.window?.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: Internal methods
    private func registerNotifications() {
        notificationCenter.addObserver(self,
            selector: Selector("keyboardWillChange:"),
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
        
        notificationCenter.addObserver(self,
            selector: Selector("keyboardWillHideNotification:"),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterNotifications() {
        notificationCenter.removeObserver(self)
    }
}

extension UIViewAnimationCurve {
    private func toOptions() -> UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}