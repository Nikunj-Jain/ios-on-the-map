//
//  Constants.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation

struct Parse {
    
    struct URLs {
        static let studentLocationURL = "https://api.parse.com/1/classes/StudentLocation"
        static let arguments = "?limit=100&order=-updatedAt"
    }
    
    struct ApiHeaderKeys {
        static let appId = "X-Parse-Application-Id"
        static let restApiKey = "X-Parse-REST-API-Key"
    }

    struct ApiHeaderValues {
        static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        static let createdAt = "createdAt"
        static let objectId = "objectId"
    }
    
    struct Keys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
}

struct errorStrings {
    static let checkConnection = "Please check internet connection."
    static let cantLoginUdacity = "Unable to Login. \(checkConnection)"
    static let createSession = "Login Failed (createSession)."
    static let invalidCredentials = "Incorrect credentials."
    static let noIDPassword = "User ID / Password is blank."
    static let getStudentLocations = "Fetching of data failed (getStudentLocations)."
    static let noSessionID = "Unable to get session ID. \(checkConnection)"
    static let cantFetchParse = "Unable to fetch data from Parse. \(checkConnection)"
    static let cantReload = "Unable to reload data. \(checkConnection)"
    static let cantLogout = "Unable to logout of current session. \(checkConnection)"
    static let noLocationEntered = "Please enter location."
    static let cantGeocode = "Geocoding failed!"
    static let noGeocodeResult = "No results returned"
    static let noMediaURLEntered = "Please enter a URL to share"
    static let cantFetchUserData = "Unable to get user data from Udacity. \(checkConnection)"
    static let cantPostDataParse = "Unable to post data to Parse. \(checkConnection)"
    
}

struct NSNotificationCenterKeys {
    static let successfulKey = "com.nickjay.Successful"
    static let unsuccessfulKey = "com.nickjay.Unsuccessful"
}

struct Methods {
    static let postMethod = "POST"
    static let deleteMethod = "DELETE"
}

struct Udacity {
    struct URLs {
        static let sessionURL = "https://www.udacity.com/api/session"
        static let userDataURL = "https://www.udacity.com/api/users/"
    }
    
    
    struct HTTPBodyKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    struct JSONResponseKeys {
        static let status = "status"
        static let account = "account"
        static let session = "session"
        static let key = "key"
        static let id = "id"
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }
}

struct HTTPHeaderKeys {
    static let accept = "Accept"
    static let contentType = "Content-Type"
}

struct HTTPHeaderValues {
    static let jsonApp = "application/json"
}