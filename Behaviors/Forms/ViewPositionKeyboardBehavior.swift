//
//  ViewPositionScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 15/01/16.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class ViewPositionKeyboardBehavior : KeyboardTriggerBehavior {
    
    @IBOutlet open weak var view: UIView!
    
    
    @IBAction open func moveViewAboveKeyboard() {
        if isEnabled {
            if let viewFrameInWindow = view.window?.convert(view.bounds, from:view) {
                let distance = viewFrameInWindow.maxY - keyboardFrame.minY
                if distance > 0 {
                    let options = UIViewAnimationOptions.beginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                    UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: -distance)
                        }, completion: nil)
                }
            }
        }
    }
    
    @IBAction open func resetViewPosition() {
        if isEnabled {
            let options = UIViewAnimationOptions.beginFromCurrentState.union(keyboardAnimationCurve.toOptions())
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
                self.view.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
    // MARK: Overwritten methods
    override func keyboardWillChange(_ notification: Notification) {
        super.keyboardWillChange(notification)
        moveViewAboveKeyboard()
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        resetViewPosition()
    }
}

extension UIViewAnimationCurve {
    fileprivate func toOptions() -> UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}
