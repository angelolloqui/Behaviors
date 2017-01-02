//
//  TextfieldBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 20/10/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class TextFieldResponderBehavior : Behavior {
    
    @IBInspectable open var dismissIfEmpty: Bool = false
    
    @IBOutlet weak var textField: UITextField? {
        willSet {
            textField?.removeTarget(self, action:
                #selector(TextFieldResponderBehavior.textFieldShouldReturn),
                                    for: .editingDidEndOnExit
            )
        }
        
        didSet {
            textField?.addTarget(self, action:
                #selector(TextFieldResponderBehavior.textFieldShouldReturn),
                                 for: .editingDidEndOnExit
            )
        }
    }
    
    @IBOutlet weak var nextTextField: UITextField?
    
    func textFieldShouldReturn() {
        guard isEnabled && (!dismissIfEmpty || textField?.text?.characters.count > 0) else { return }
        nextTextField?.becomeFirstResponder()
    }
}
