//
//  ScrollingTriggerBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 25/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class ScrollingTriggerBehavior : Behavior {
    @IBInspectable open var minimumOffset: CGFloat = 64.0
    @IBInspectable open var enterScrollDownOffset: CGFloat = 100.0
    @IBInspectable open var exitScrollUpOffset: CGFloat = 300.0
    
    var active: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView? {
        willSet {
            scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        
        didSet {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
    }
    var lastChangePoint = CGPoint.zero
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    @IBAction open func touchDragEnter() {
        if let offset = scrollView?.contentOffset {
            lastChangePoint = offset
        }
        self.sendActions(for: UIControlEvents.touchDragEnter)
        active = true
    }
    
    @IBAction open func touchDragExit() {
        if let offset = scrollView?.contentOffset {
            lastChangePoint = offset
        }
        self.sendActions(for: UIControlEvents.touchDragExit)
        active = false
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.isEnabled {
            if let keyPath = keyPath, keyPath == "contentOffset",
                let scrollView = object as? UIScrollView, scrollView == self.scrollView,
                let newOffset = change?[NSKeyValueChangeKey.newKey] as? NSValue,
                let oldOffset = change?[NSKeyValueChangeKey.oldKey] as? NSValue {
                    
                    let newPoint = newOffset.cgPointValue
                    let oldPoint = oldOffset.cgPointValue
                    let deltaY = newPoint.y - lastChangePoint.y
                    
                    if newPoint.y > oldPoint.y {
                        //Scrolling down
                        if deltaY > enterScrollDownOffset && newPoint.y > minimumOffset {
                            touchDragEnter()
                        }
                    }
                    else {
                        //Scrolling up
                        if -deltaY > exitScrollUpOffset || newPoint.y < minimumOffset {
                            touchDragExit()
                        }
                    }
            }
        }
    }
}
