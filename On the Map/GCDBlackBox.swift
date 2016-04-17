//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Nikunj Jain on 17/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}