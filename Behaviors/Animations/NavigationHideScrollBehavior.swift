//
//  NavigationHideScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 09/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class NavigationHideScrollBehavior : Behavior {
    
    @IBInspectable public var minimumScrollOffset: CGFloat = 0
    @IBInspectable public var maximumScrollOffset: CGFloat = 100
    @IBInspectable public var minimumScrollSpeed: CGFloat = 30
    
    @IBOutlet weak var scrollView: UIScrollView? {
        willSet {
             scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        
        didSet {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: nil)
        }
    }
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    @IBAction public func hideNavigationBar() {
        setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction public func showNavigationBar() {
        setNavigationBarHidden(false, animated: true)
    }
    
    public func setNavigationBarHidden(hidden: Bool, animated: Bool = true) {
        if let navController = findNavigationController() {
            if navController.navigationBarHidden != hidden {
                navController.setNavigationBarHidden(hidden, animated: animated)
                self.sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    public func findNavigationController() -> UINavigationController? {
        var responder = scrollView?.nextResponder()
        while responder != nil {
            if let vc = responder as? UIViewController {
                if vc.navigationController != nil {
                    return vc.navigationController
                }
            }
            responder = responder?.nextResponder()
        }
        return nil
    }

    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let keyPath = keyPath where keyPath == "contentOffset",
            let scrollView = object as? UIScrollView where scrollView == self.scrollView,
            let newOffset = change?[NSKeyValueChangeNewKey] as? NSValue,
            let oldOffset = change?[NSKeyValueChangeOldKey] as? NSValue {
                let newY = newOffset.CGPointValue().y
                let deltaY = newY - oldOffset.CGPointValue().y
                if (deltaY > minimumScrollSpeed &&  newY > minimumScrollOffset) || (newY > maximumScrollOffset && maximumScrollOffset > 0) {
                    hideNavigationBar()
                }
                else if deltaY < -minimumScrollSpeed || newY < minimumScrollOffset  {
                    showNavigationBar()
                }
        }
    }
    
}
