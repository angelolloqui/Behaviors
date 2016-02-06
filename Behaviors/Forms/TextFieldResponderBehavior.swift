//
//  TextfieldBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 20/10/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldResponderBehavior : Behavior {
    
    @IBInspectable public var dismissIfEmpty: Bool = false

    @IBOutlet weak var textField: UITextField? {
        willSet {
            textField?.removeTarget(self, action:
                Selector("textFieldShouldReturn"),
                forControlEvents: .EditingDidEndOnExit
            )
        }
        
        didSet {
            textField?.addTarget(self, action:
                Selector("textFieldShouldReturn"),
                forControlEvents: .EditingDidEndOnExit
            )
        }
    }
    
    @IBOutlet weak var nextTextField: UITextField?
    
    func textFieldShouldReturn() {
        guard !dismissIfEmpty || textField?.text?.characters.count > 0 else { return }
        nextTextField?.becomeFirstResponder()
    }
}