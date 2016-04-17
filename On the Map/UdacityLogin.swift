//
//  UdacityLogin.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation

class UdacityLogin {
    
    private static var sharedInstance = UdacityLogin()    
    
    class func sharedUdacityInstance() -> UdacityLogin {
        return sharedInstance
    }
    
    func authAndFetch(username: String, password: String, authAndFetchCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        createSession(username, password: password) { (success, errorString) in
            if success {
                self.getStudentLocations(){ (success, errorString) in
                    authAndFetchCompletionHandler(success: success, errorString: errorString)
                }
            } else {
                    authAndFetchCompletionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func createSession(username: String, password: String, createSessionCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.URLs.sessionURL)!)
        request.HTTPMethod = Methods.postMethod
        request.addValue(HTTPHeaderValues.jsonApp, forHTTPHeaderField: HTTPHeaderKeys.accept)
        request.addValue(HTTPHeaderValues.jsonApp, forHTTPHeaderField: HTTPHeaderKeys.contentType)
        request.HTTPBody = "{\"\(Udacity.HTTPBodyKeys.udacity)\": {\"\(Udacity.HTTPBodyKeys.username)\": \"\(username)\", \"\(Udacity.HTTPBodyKeys.password)\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                createSessionCompletionHandler(success: false, errorString: errorStrings.cantLoginUdacity)
                return
            }
            
            guard let data = data else {
                createSessionCompletionHandler(success: false, errorString: errorStrings.cantLoginUdacity)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var parsedData: AnyObject
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                createSessionCompletionHandler(success: false, errorString: errorStrings.createSession)
                return
            }
            
            if let status = parsedData[Udacity.JSONResponseKeys.status] as? Int {
                if status == 403 {
                    createSessionCompletionHandler(success: false, errorString: errorStrings.invalidCredentials)
                    return
                }
            }
            
            guard let accountDictionary = parsedData[Udacity.JSONResponseKeys.account] as? [String: AnyObject], sessionDictionary = parsedData[Udacity.JSONResponseKeys.session] as? [String: AnyObject], userID =  accountDictionary[Udacity.JSONResponseKeys.key] as? String ,sessionID = sessionDictionary[Udacity.JSONResponseKeys.id] as? String else {
                createSessionCompletionHandler(success: false, errorString: errorStrings.noSessionID)
                return
            }
            
            currentUser.uniqueKey = userID
            udacitySessionID = sessionID
            createSessionCompletionHandler(success: true, errorString: nil)
            
        }
            
        task.resume()
    }
    
    func getStudentLocations (getStudentsLocationCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Parse.URLs.studentLocationURL)\(Parse.URLs.arguments)")!)
        request.addValue(Parse.ApiHeaderValues.appId, forHTTPHeaderField: Parse.ApiHeaderKeys.appId)
        request.addValue(Parse.ApiHeaderValues.restApiKey, forHTTPHeaderField: Parse.ApiHeaderKeys.restApiKey)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                getStudentsLocationCompletionHandler(success: false, errorString: errorStrings.cantFetchParse)
                return
            }
            
            guard let data = data else {
                getStudentsLocationCompletionHandler(success: false, errorString: errorStrings.cantFetchParse)
                return
            }
            
            var parsedData: AnyObject
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                getStudentsLocationCompletionHandler(success: false, errorString: errorStrings.getStudentLocations)
                return
            }
            
            guard let resultArray = parsedData[Parse.JSONResponseKeys.results] as? [[String: AnyObject]] else {
                getStudentsLocationCompletionHandler(success: false, errorString: errorStrings.getStudentLocations)
                return
            }
            
            studentsArray = resultArray
            
            getStudentsLocationCompletionHandler(success: true, errorString: nil)

        }
        
        task.resume()
    }
    
    func logout (logoutCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.URLs.sessionURL)!)
        request.HTTPMethod = Methods.deleteMethod
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                logoutCompletionHandler(success: false, errorString: errorStrings.cantLogout)
                return
            }
            
            logoutCompletionHandler(success: true, errorString: nil)
        
        }
        task.resume()
    }
    
    func getUserData (getUserDataCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Udacity.URLs.userDataURL)\(currentUser.uniqueKey!)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                getUserDataCompletionHandler(success: false, errorString: errorStrings.cantFetchUserData)
                return
            }
            
            guard let data = data else {
                getUserDataCompletionHandler(success: false, errorString: errorStrings.cantFetchUserData)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            var parsedData: AnyObject
            
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                getUserDataCompletionHandler(success: false, errorString: errorStrings.cantFetchUserData)
                return
            }
            
            guard let userDictionary = parsedData[Udacity.JSONResponseKeys.user] as? [String: AnyObject], firstName = userDictionary[Udacity.JSONResponseKeys.firstName] as? String, lastName = userDictionary[Udacity.JSONResponseKeys.lastName] as? String else {
                getUserDataCompletionHandler(success: false, errorString: errorStrings.cantFetchUserData)
                return
            }
            currentUser.firstName = firstName
            currentUser.lastName = lastName
            
            getUserDataCompletionHandler(success: true, errorString: nil)
        }
        task.resume()
        
    }
    
    func postUserData (mapString: String, postUserDataCompletionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Parse.URLs.studentLocationURL)!)
        request.HTTPMethod = Methods.postMethod
        request.addValue(Parse.ApiHeaderValues.appId, forHTTPHeaderField: Parse.ApiHeaderKeys.appId)
        request.addValue(Parse.ApiHeaderValues.restApiKey, forHTTPHeaderField: Parse.ApiHeaderKeys.restApiKey)
        request.addValue(HTTPHeaderValues.jsonApp, forHTTPHeaderField: HTTPHeaderKeys.contentType)
        request.HTTPBody = "{\"\(Parse.Keys.uniqueKey)\": \"\(currentUser.uniqueKey!)\", \"\(Parse.Keys.firstName)\": \"\(currentUser.firstName!)\", \"\(Parse.Keys.lastName)\": \"\(currentUser.lastName!)\",\"\(Parse.Keys.mapString)\": \"\(mapString)\", \"\(Parse.Keys.mediaURL)\": \"\(currentUser.mediaURL!)\",\"\(Parse.Keys.latitude)\": \(currentUser.latitude!), \"\(Parse.Keys.longitude)\": \(currentUser.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                postUserDataCompletionHandler(success: false, errorString: errorStrings.cantPostDataParse)
                return
            }
            
            guard let data = data else {
                postUserDataCompletionHandler(success: false, errorString: errorStrings.cantPostDataParse)
                return
            }
            
            var parsedData: AnyObject
            do {
                parsedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                postUserDataCompletionHandler(success: false, errorString: errorStrings.cantPostDataParse)
                return
            }
            
            guard let _ = parsedData[Parse.JSONResponseKeys.createdAt] as? String, _ = parsedData[Parse.JSONResponseKeys.objectId] else {
                postUserDataCompletionHandler(success: false, errorString: errorStrings.cantPostDataParse)
                return
            }
            
            postUserDataCompletionHandler(success: true, errorString: nil)
            
        }
        task.resume()
    }
    
    private func sendDataNotification(notificationName: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    // MARK: Refresh Student Locations
    
    func refreshStudentLocations() {
        getStudentLocations { (success, error) in
            performUIUpdatesOnMain() {
                if !success {
                    self.sendDataNotification(NSNotificationCenterKeys.unsuccessfulKey)
                } else {
                    self.sendDataNotification(NSNotificationCenterKeys.successfulKey)
                }
            }
        }
    }
}