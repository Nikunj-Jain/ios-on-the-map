//
//  AppDelegate.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit

var studentsArray = [[String: AnyObject]]()
var udacitySessionID: String!
var currentUser = Student()

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

