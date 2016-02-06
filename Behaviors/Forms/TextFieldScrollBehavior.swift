//
//  TextFieldScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldScrollBehavior : Behavior {
    @IBOutlet public var textFields: [UITextField]?
    @IBOutlet public weak var scrollView: UIScrollView?
    @IBInspectable public var insetEnabled: Bool = true
    @IBInspectable public var offsetEnabled: Bool = true
    @IBInspectable public var bottomMargin: CGFloat = 5
    
    var keyboardFrame = CGRectZero
    var keyboardAnimationDuration:NSTimeInterval = 0.25
    var keyboardAnimationCurve = UIViewAnimationCurve.EaseOut
    var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    var appliedInsetSize = CGSizeZero
    
    
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
    
    //MARK: Public methods
    @IBAction public func autoScroll(animated: Bool = true)  {
        if let textField = responderTextField() {
            self.configureScrollInsets(keyboardFrame.size, animated: animated)
            self.configureScrollOffset(textField, animated: animated)
        }
        else {
            self.configureScrollInsets(CGSizeZero, animated: animated)
        }
    }
    
    
    //MARK: Notification and Listener methods
    @objc private func editingDidBegin(textfield: UITextField) {
        self.autoScroll(true)
    }
    
    @objc private func editingDidEnd(textfield: UITextField) {
        self.autoScroll(true)
    }
    
    @objc private func keyboardWillChange(notification: NSNotification) {
        readNotificationInformation(notification)
        self.autoScroll(true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        readNotificationInformation(notification)
        self.configureScrollInsets(CGSizeZero, animated: true)
    }
    
    //MARK: Internal methods
    private func registerNotifications() {
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
    
    private func configureScrollInsets(size: CGSize, animated: Bool = true) {
        if insetEnabled && scrollView != nil {
            let scrollView = self.scrollView!
            let deltaY = size.height - appliedInsetSize.height
            if deltaY != 0 {
                var contentInsets = scrollView.contentInset
                var scrollInsets = scrollView.scrollIndicatorInsets
                contentInsets.bottom += deltaY
                scrollInsets.bottom += deltaY
                if animated {
                    let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                    UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
                        scrollView.contentInset = contentInsets
                        scrollView.scrollIndicatorInsets = scrollInsets
                        }, completion: nil)
                }
                else {
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = scrollInsets
                }
                appliedInsetSize = size
            }
        }
    }
    
    private func configureScrollOffset(textField: UITextField, animated: Bool = true) {
        if offsetEnabled {
            if  let scrollView = self.scrollView,
                let frameInWindow = scrollView.window?.convertRect(textField.bounds, fromView: textField) {
                    let yBelowKeyboard = CGRectGetMaxY(frameInWindow) - keyboardFrame.origin.y + bottomMargin
                    if yBelowKeyboard > 0 {
                        var bounds = scrollView.bounds
                        bounds.origin.y += yBelowKeyboard
                        if (animated) {
                            let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                            UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
                                scrollView.bounds = bounds
                                }, completion: nil)
                        }
                        else {
                            scrollView.bounds = bounds
                        }
                    }
            }
        }
    }
    
    private func responderTextField() -> UITextField? {
        return textFields?.filter { return $0.isFirstResponder() }.first
    }
    
}

extension UIViewAnimationCurve {
    private func toOptions() -> UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}