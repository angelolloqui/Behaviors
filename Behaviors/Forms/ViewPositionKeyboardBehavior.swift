//
//  ViewPositionScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 15/01/16.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class ViewPositionKeyboardBehavior : KeyboardTriggerBehavior {
    
    @IBOutlet public weak var view: UIView!
    
    
    @IBAction public func moveViewAboveKeyboard() {
        if enabled {
            if let viewFrameInWindow = view.window?.convertRect(view.bounds, fromView:view) {
                let distance = CGRectGetMaxY(viewFrameInWindow) - CGRectGetMinY(keyboardFrame)
                if distance > 0 {
                    let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
                    UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
                        self.view.transform = CGAffineTransformMakeTranslation(0, -distance)
                        }, completion: nil)
                }
            }
        }
    }
    
    @IBAction public func resetViewPosition() {
        if enabled {
            let options = UIViewAnimationOptions.BeginFromCurrentState.union(keyboardAnimationCurve.toOptions())
            UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: options, animations: {
                self.view.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    //MARK: Overwritten methods
    override func keyboardWillChange(notification: NSNotification) {
        super.keyboardWillChange(notification)
        moveViewAboveKeyboard()
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification)
        resetViewPosition()
    }
}

extension UIViewAnimationCurve {
    private func toOptions() -> UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}