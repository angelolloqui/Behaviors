//
//  FormListViewController.swift
//  Behaviors
//
//  Created by Angel Garcia on 09/05/15.
//  Copyright (c) 2015 angelolloqui.com. All rights reserved.
//

import UIKit

class FormListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let behaviours = [
        "TextFieldScrollBehavior"
    ]
    
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return behaviours.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BehaviorCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = behaviours[indexPath.row]
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(behaviours[indexPath.row], sender: self)
    }

}
