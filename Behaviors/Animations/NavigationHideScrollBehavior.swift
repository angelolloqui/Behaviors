//
//  NavigationHideScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 09/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

public class NavigationHideScrollBehavior : ScrollingTriggerBehavior {
    
    @IBAction public override func touchDragEnter() {
        super.touchDragEnter()
        hideNavigationBar()
    }
    
    @IBAction public override func touchDragExit() {
        super.touchDragExit()
        showNavigationBar()
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
    
}
