//
//  NavigationHideScrollBehavior.swift
//  Behaviors
//
//  Created by Angel Garcia on 09/02/16.
//  Copyright © 2016 angelolloqui.com. All rights reserved.
//

import Foundation
import UIKit

open class NavigationHideScrollBehavior : ScrollingTriggerBehavior {
    @IBInspectable open var navigationBarEnabled: Bool = true
    @IBInspectable open var tabBarEnabled: Bool = false

    // MARK: Public actions
    @IBAction open override func touchDragEnter() {
        super.touchDragEnter()
        hideNavigationBar()
        hideTabBar()
    }
    
    @IBAction open override func touchDragExit() {
        super.touchDragExit()
        showNavigationBar()
        showTabBar()
    }
    
    @IBAction open func hideNavigationBar() {
        setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction open func showNavigationBar() {
        setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction open func hideTabBar() {
        setTabBarHidden(true, animated: true)
    }
    
    @IBAction open func showTabBar() {
        setTabBarHidden(false, animated: true)
    }
    
    
    open func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        if isEnabled && navigationBarEnabled {
            if let navController = findNavigationController() {
                if navController.isNavigationBarHidden != hidden {
                    navController.setNavigationBarHidden(hidden, animated: animated)
                    self.sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    
    open func setTabBarHidden(_ hidden: Bool, animated: Bool = true) {
        if isEnabled && tabBarEnabled {
            if let tabController = findTabBarController() {
                if tabController.tabBar.isHidden != hidden {
                    tabController.tabBar.isHidden = hidden
                    self.sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    // MARK: Private methods
    var navController: UINavigationController?
    func findNavigationController() -> UINavigationController? {
        guard navController == nil else { return navController }
        var responder = scrollView?.next
        while responder != nil {
            if let vc = responder as? UIViewController {
                if vc.navigationController != nil {
                    navController = vc.navigationController
                    return vc.navigationController
                }
            }
            responder = responder?.next
        }
        return nil
    }
    
    var tabController: UITabBarController?
    func findTabBarController() -> UITabBarController? {
        guard tabController == nil else { return tabController }
        var responder = scrollView?.next
        while responder != nil {
            if let vc = responder as? UIViewController {
                if vc.tabBarController != nil {
                    tabController = vc.tabBarController
                    return vc.tabBarController
                }
            }
            responder = responder?.next
        }
        return nil
    }

}
