//
//  TextFieldScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldScrollBehavior : KeyboardTriggerBehavior {
    @IBOutlet public var textFields: [UITextField]?
    @IBOutlet public weak var scrollView: UIScrollView?
    @IBInspectable public var insetEnabled: Bool = true
    @IBInspectable public var offsetEnabled: Bool = true
    @IBInspectable public var bottomMargin: CGFloat = 5
    
    var appliedInsetSize = CGSizeZero
    
    
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
    
    //MARK: Overwritten methods
    @objc override func keyboardWillChange(notification: NSNotification) {
        super.keyboardWillChange(notification)
        self.autoScroll(true)
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification)
        self.configureScrollInsets(CGSizeZero, animated: true)
    }
    
    //MARK: Internal methods
    
    private func configureScrollInsets(size: CGSize, animated: Bool = true) {
        if enabled && insetEnabled && scrollView != nil {
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
        if enabled && offsetEnabled {
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