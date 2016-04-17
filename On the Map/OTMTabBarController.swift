//
//  OTMTabBarController.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation
import UIKit

class OTMTabBarController: UITabBarController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    let sharedUdacityInstance = UdacityLogin.sharedUdacityInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableUI(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createErrorAlert", name: NSNotificationCenterKeys.unsuccessfulKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        sharedUdacityInstance.refreshStudentLocations()
    }

    func createErrorAlert() {
        createAlert(self, error: errorStrings.cantReload)
    }
    
    
    @IBAction func logoutUser(sender: UIBarButtonItem) {
        enableUI(false)
        sharedUdacityInstance.logout { (success, errorString) -> Void in
            if !success {
                if errorString == errorStrings.cantLogout {
                    performUIUpdatesOnMain() {
                        self.enableUI(true)
                        createAlert(self, error: errorString!)
                    }
                }
            } else {
                performUIUpdatesOnMain() {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func enableUI(shouldEnable: Bool) {
        pinButton.enabled = shouldEnable
        refreshButton.enabled = shouldEnable
        logoutButton.enabled = shouldEnable
        for item in tabBar.items! {
            item.enabled = shouldEnable
        }
    }
    
}
