//
//  MockNotificationCenter.swift
//  Behaviors
//
//  Created by Angel Garcia on 29/04/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation

// MARK: Mock objects
class MockNotificationCenter : NotificationCenter {
    struct ObserverInfo : Equatable {
        weak var observer: AnyObject?
        let selector: Selector
        let name: String
    }
    
    var observers = [ObserverInfo]()
    
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        let observerInfo = ObserverInfo(observer: observer as AnyObject?, selector: aSelector, name: aName!.rawValue)
        observers.append(observerInfo)
        super.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        observers = observers.filter({ (elem) -> Bool in
            (aName != nil && elem.name != aName?.rawValue) || (elem.observer != nil && elem.observer! !== (observer as AnyObject))
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
