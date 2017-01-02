//
//  TextFieldScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldScrollBehavior: KeyboardTriggerBehavior {
    @IBOutlet open var textFields: [UITextField]?
    @IBOutlet open weak var scrollView: UIScrollView?
    @IBInspectable open var insetEnabled: Bool = true
    @IBInspectable open var offsetEnabled: Bool = true
    @IBInspectable open var bottomMargin: CGFloat = 5

    var appliedInsetSize = CGSize.zero

    // MARK: Public methods
    @IBAction open func autoScroll(_ animated: Bool = true) {
        if let textField = responderTextField() {
            self.configureScrollInsets(keyboardFrame.size, animated: animated)
            self.configureScrollOffset(textField, animated: animated)
        } else {
            self.configureScrollInsets(CGSize.zero, animated: animated)
        }
    }

    // MARK: Notification and Listener methods
    @objc fileprivate func editingDidBegin(_ textfield: UITextField) {
        self.autoScroll(true)
    }

    @objc fileprivate func editingDidEnd(_ textfield: UITextField) {
        self.autoScroll(true)
    }

    // MARK: Overwritten methods
    @objc override func keyboardWillChange(_ notification: Notification) {
        super.keyboardWillChange(notification)
        self.autoScroll(true)
    }

    @objc override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        self.configureScrollInsets(CGSize.zero, animated: true)
    }

    // MARK: Internal methods

    fileprivate func configureScrollInsets(_ size: CGSize, animated: Bool = true) {
        if let scrollView = self.scrollView, isEnabled, insetEnabled {
            let deltaY = size.height - appliedInsetSize.height
            if deltaY != 0 {
                var contentInsets = scrollView.contentInset
                var scrollInsets = scrollView.scrollIndicatorInsets
                contentInsets.bottom += deltaY
                scrollInsets.bottom += deltaY
                if animated {
                    let options = UIViewAnimationOptions.beginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                    UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
                        scrollView.contentInset = contentInsets
                        scrollView.scrollIndicatorInsets = scrollInsets
                        }, completion: nil)
                } else {
                    scrollView.contentInset = contentInsets
                    scrollView.scrollIndicatorInsets = scrollInsets
                }
                appliedInsetSize = size
            }
        }
    }

    fileprivate func configureScrollOffset(_ textField: UITextField, animated: Bool = true) {
        if isEnabled && offsetEnabled {
            if  let scrollView = self.scrollView,
                let frameInWindow = scrollView.window?.convert(textField.bounds, from: textField) {
                    let yBelowKeyboard = frameInWindow.maxY - keyboardFrame.origin.y + bottomMargin
                    if yBelowKeyboard > 0 {
                        var bounds = scrollView.bounds
                        bounds.origin.y += yBelowKeyboard
                        if animated {
                            let options = UIViewAnimationOptions.beginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
                                scrollView.bounds = bounds
                                }, completion: nil)
                        } else {
                            scrollView.bounds = bounds
                        }
                    }
            }
        }
    }

    fileprivate func responderTextField() -> UITextField? {
        return textFields?.filter { return $0.isFirstResponder }.first
    }

}

extension UIViewAnimationCurve {
    fileprivate func toOptions() -> UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}
