//
//  AlertView.swift
//  On the Map
//
//  Created by Nikunj Jain on 19/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit


func createAlert(viewController: UIViewController, error: String) {
    let alert = UIAlertController(title: "Warning", message: error, preferredStyle: .Alert)
    
    let dismissButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) { (action) -> Void in
        alert.dismissViewControllerAnimated(true, completion: nil)
    }
    
    alert.addAction(dismissButton)
    viewController.presentViewController(alert, animated: true, completion: nil)
}