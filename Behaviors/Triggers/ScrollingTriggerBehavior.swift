//
//  ScrollingTriggerBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 25/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class ScrollingTriggerBehavior : Behavior {
    @IBInspectable public var minimumOffset: CGFloat = 64.0
    @IBInspectable public var enterScrollDownOffset: CGFloat = 100.0
    @IBInspectable public var exitScrollUpOffset: CGFloat = 300.0
    
    var active: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView? {
        willSet {
            scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        
        didSet {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: nil)
        }
    }
    var lastChangePoint = CGPointZero
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    @IBAction public func touchDragEnter() {
        if let offset = scrollView?.contentOffset {
            lastChangePoint = offset
        }
        self.sendActionsForControlEvents(UIControlEvents.TouchDragEnter)
        active = true
    }
    
    @IBAction public func touchDragExit() {
        if let offset = scrollView?.contentOffset {
            lastChangePoint = offset
        }
        self.sendActionsForControlEvents(UIControlEvents.TouchDragExit)
        active = false
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if self.enabled {
            if let keyPath = keyPath where keyPath == "contentOffset",
                let scrollView = object as? UIScrollView where scrollView == self.scrollView,
                let newOffset = change?[NSKeyValueChangeNewKey] as? NSValue,
                let oldOffset = change?[NSKeyValueChangeOldKey] as? NSValue {
                    
                    let newPoint = newOffset.CGPointValue()
                    let oldPoint = oldOffset.CGPointValue()
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