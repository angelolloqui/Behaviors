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

class Behavior : UIControl {
    @IBOutlet weak var owner: AnyObject? {
        willSet (v) {
            if owner != nil {
                self.releaseLifetimeFromObject(owner!)
            }
        }
        didSet (v) {
            if owner != nil {
                self.bindLifetimeToObject(owner!)
            }
        }        
    }

    private func bindLifetimeToObject(object: AnyObject) {
        let pointer = unsafeAddressOf(self)
        objc_setAssociatedObject(object, pointer, self, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

    private func releaseLifetimeFromObject(object: AnyObject) {
        let pointer = unsafeAddressOf(self)
        objc_setAssociatedObject(object, pointer, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

}