//
//  MockNotificationCenter.swift
//  Behaviors
//
//  Created by Angel Garcia on 29/04/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation

//MARK: Mock objects
class MockNotificationCenter : NSNotificationCenter {
    struct ObserverInfo : Equatable {
        weak var observer: AnyObject?
        let selector: Selector
        let name: String
    }
    
    var observers = [ObserverInfo]()
    
    override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
        let observerInfo = ObserverInfo(observer: observer, selector: aSelector, name: aName!)
        observers.append(observerInfo)
        super.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    override func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?) {
        observers = observers.filter({ (elem) -> Bool in
            (aName != nil && elem.name != aName) || (elem.observer != nil && elem.observer !== observer)
        })
        super.removeObserver(observer, name: aName, object: anObject)
    }
    
}

func ==(lhs: MockNotificationCenter.ObserverInfo, rhs: MockNotificationCenter.ObserverInfo) -> Bool {
    if  let observer1 = lhs.observer as? NSObject,
        let observer2 = rhs.observer as? NSObject {
        return observer1 == observer2 &&
            lhs.selector == rhs.selector &&
            lhs.name == rhs.name
    }
    return false
}
