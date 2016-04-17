//
//  Student.swift
//  On the Map
//
//  Created by Nikunj Jain on 17/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation

struct Student {
    
   // var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    init(studentDictionary: [String: AnyObject]) {
      //  objectId = studentDictionary[StudentJSONKeys.objectId] as? String
        uniqueKey = studentDictionary[Parse.Keys.uniqueKey] as? String
        firstName = studentDictionary[Parse.Keys.firstName] as? String
        lastName = studentDictionary[Parse.Keys.lastName] as? String
        latitude = studentDictionary[Parse.Keys.latitude] as? Double
        longitude = studentDictionary[Parse.Keys.longitude] as? Double
        mediaURL = studentDictionary[Parse.Keys.mediaURL] as? String
    }
    
    init() {
        
    }
    
    func getName() -> String {
        return "\(firstName!) \(lastName!)"
    }
    
}