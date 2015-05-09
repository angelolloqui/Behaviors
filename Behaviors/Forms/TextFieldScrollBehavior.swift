//
//  KeyboardScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldScrollBehavior : Behavior {
    @IBOutlet public var textFields: [UITextField]!
    @IBOutlet public weak var scrollView: UIScrollView!
    @IBInspectable public var insetEnabled: Bool = true
    @IBInspectable public var offsetEnabled: Bool = true
    @IBInspectable public var bottomMargin: Float = 5
    
    var keyboardFrame = CGRectZero
    var keyboardAnimationDuration:Float = 0
    var keyboardAnimationCurve = UIViewAnimationCurve.EaseOut
    var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    convenience init(notificationCenter nc: NSNotificationCenter) {
        self.init(frame: CGRectZero, notificationCenter: nc)
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, notificationCenter: NSNotificationCenter.defaultCenter())
    }
    
    init(frame: CGRect, notificationCenter nc: NSNotificationCenter) {
        notificationCenter = nc
        super.init(frame: frame)
        
        notificationCenter.addObserver(
            self,
            selector: "keyboardWillChange:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Public methods
    @IBAction public func autoScroll(animated: Bool = true)  {
        for textField in textFields {
            if textField.isFirstResponder() {
                self.configureScrollInsets(keyboardFrame.size, animated: animated)
                self.configureScrollOffset(textField, animated: animated)
            }
        }
    }
    
    //MARK: Internal methods
    func registerNotifications() {
        notificationCenter.addObserver(
            self,
            selector: "keyboardWillChange:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)
    }
    
    func keyboardWillChange(notification: NSNotification) {
        if  let userInfo = notification.userInfo {
            
            if let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                keyboardFrame = keyboardFrameValue.CGRectValue()
            }
            
            if let keyboardAnimDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                keyboardAnimationDuration = keyboardAnimDurationValue.floatValue
            }
            
            if let keyboardAnimationCurveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
                keyboardAnimationCurve = UIViewAnimationCurve(rawValue: keyboardAnimationCurveValue.integerValue)!
            }
        }
    }
    
    
    func configureScrollInsets(size: CGSize, animated: Bool = true) {
        if insetEnabled {
            
        }
    }

    func configureScrollOffset(textField: UITextField, animated: Bool = true) {
        if offsetEnabled {
            
        }
    }

    
}