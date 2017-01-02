//
//  Behavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 09/04/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

@objc
open class Behavior : UIControl {
    @IBOutlet weak var owner: AnyObject? {
        willSet (new) {
            if let new: AnyObject = new {
                self.bindLifetimeToObject(new)
            }
            if let owner: AnyObject = owner {
                self.releaseLifetimeFromObject(owner)
            }
        }
    }
    
    fileprivate func bindLifetimeToObject(_ object: AnyObject) {
        let pointer = Unmanaged.passUnretained(self).toOpaque()
        objc_setAssociatedObject(object, pointer, self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    fileprivate func releaseLifetimeFromObject(_ object: AnyObject) {
        let pointer = Unmanaged.passUnretained(self).toOpaque()
        objc_setAssociatedObject(object, pointer, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    override open var next: UIResponder? {
        get {
            return super.next ?? self.owner as? UIResponder
        }
    }
}


