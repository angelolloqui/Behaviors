//
//  TextFieldValidatorBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 05/04/16.
//  Copyright (c) 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldValidatorBehavior : Behavior {
    @IBInspectable var validateOnChange: Bool = true
    @IBInspectable var allowsEmpty: Bool = true
    @IBInspectable var message: String?
    @IBOutlet weak var textField: UITextField! {
        willSet {
            textField?.removeTarget(self, action:
                #selector(TextFieldValidatorBehavior.textFieldShouldReturn),
                                    forControlEvents: .EditingDidEndOnExit
            )
            textField?.removeTarget(self, action:
                #selector(TextFieldValidatorBehavior.textFieldDidChange),
                                    forControlEvents: .EditingChanged
            )
        }
        
        didSet {
            textField.addTarget(self, action:
                #selector(TextFieldValidatorBehavior.textFieldShouldReturn),
                                forControlEvents: .EditingDidEndOnExit
            )
            textField.addTarget(self, action:
                #selector(TextFieldValidatorBehavior.textFieldDidChange),
                                forControlEvents: .EditingChanged
            )
        }
    }
    @IBOutlet weak var nextTextField: UITextField?
    var isValid: Bool = true
    var regularExpression: String?
    
    @IBAction func validate() {
        if !allowsEmpty && textField.text?.characters.count == 0 {
            isValid = false
        }
        else if let regex = regularExpression {
            isValid = matchesRegularExpression(regex)
        }
        else {
            isValid = true
        }
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func textFieldShouldReturn() {
        validate()
        if isValid {
            nextTextField?.becomeFirstResponder()
        }
        else {
            //Retake the first responder to continue editing
            dispatch_async(dispatch_get_main_queue()) {
                self.textField.becomeFirstResponder()
            }
        }
    }
    
    func textFieldDidChange() {
        if validateOnChange {
            validate()
        }
    }
    
    func matchesRegularExpression(regex: String) -> Bool {
        guard let text = textField.text, let expression = try? NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.CaseInsensitive) else { return false }
        let matchRange = expression.rangeOfFirstMatchInString(text, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, text.characters.count))
        return matchRange.location != NSNotFound && matchRange.length == text.characters.count
    }
}

public class TextFieldRegexValidatorBehavior : TextFieldValidatorBehavior {
    @IBInspectable var regex: String? {
        didSet {
            regularExpression = regex
        }
    }
}


public class TextFieldEmailValidatorBehavior : TextFieldValidatorBehavior {
    public override func awakeFromNib() {
        super.awakeFromNib()
        regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    }
}


public class TextFieldPhoneValidatorBehavior : TextFieldValidatorBehavior {
    public override func awakeFromNib() {
        super.awakeFromNib()
        regularExpression = "[0-9+-]{8,13}"
    }
}

public class TextFieldCreditCardExiprationValidatorBehavior: TextFieldValidatorBehavior {
    
    var isExpired: Bool {
        if let expiration = self.textField.text where self.textField.text?.characters.count == 5 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            let date = dateFormatter.dateFromString(expiration)
            return date?.compare(NSDate()) == .OrderedAscending
        }
        return true
    }
    
    override var isValid: Bool {
        get {
            return super.isValid && !self.isExpired
        }
        set(valid) { super.isValid = valid }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        regularExpression = "^(0[1-9]|1[0-2])\\/?([0-9]{4}|[0-9]{2})$"
    }
}

public class TextFieldCreditCardValidatorBehavior : TextFieldValidatorBehavior {
    @IBInspectable var visa: Bool = true
    @IBInspectable var masterCard: Bool = true
    @IBInspectable var americanExpress: Bool = true
    @IBInspectable var dinersClub: Bool = true
    @IBInspectable var discover: Bool = true
    
    static let VisaRegex = "4[0-9]{15}"
    static let MasterCardRegex = "5[1-5][0-9]{14}"
    static let AmericanExpressRegex = "3[47][0-9]{13}"
    static let DinersClubRegex = "3(?:0[0-5]|[68][0-9])[0-9]{11}"
    static let DiscoverRegex = "6(?:011|5[0-9]{2})[0-9]{12}"
    
    var isVisa: Bool {
        return matchesRegularExpression(TextFieldCreditCardValidatorBehavior.VisaRegex)
    }
    var isMasterCard: Bool {
        return matchesRegularExpression(TextFieldCreditCardValidatorBehavior.MasterCardRegex)
    }
    var isAmericanExpress: Bool {
        return matchesRegularExpression(TextFieldCreditCardValidatorBehavior.AmericanExpressRegex)
    }
    var isDinersClub: Bool {
        return matchesRegularExpression(TextFieldCreditCardValidatorBehavior.DinersClubRegex)
    }
    var isDiscover: Bool {
        return matchesRegularExpression(TextFieldCreditCardValidatorBehavior.DiscoverRegex)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        var expressions:[String] = []
        if visa {
            expressions.append(TextFieldCreditCardValidatorBehavior.VisaRegex)
        }
        if masterCard {
            expressions.append(TextFieldCreditCardValidatorBehavior.MasterCardRegex)
        }
        if americanExpress {
            expressions.append(TextFieldCreditCardValidatorBehavior.AmericanExpressRegex)
        }
        if dinersClub {
            expressions.append(TextFieldCreditCardValidatorBehavior.DinersClubRegex)
        }
        if discover {
            expressions.append(TextFieldCreditCardValidatorBehavior.DiscoverRegex)
        }
        regularExpression = expressions.map { "(\($0))" }.joinWithSeparator("|")
    }
    
}
