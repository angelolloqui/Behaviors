//
//  TextfieldBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 20/10/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldResponderBehavior: Behavior {

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
        guard isEnabled && (!dismissIfEmpty || (textField?.text?.characters.count ?? 0) > 0) else { return }
        nextTextField?.becomeFirstResponder()
    }
}
