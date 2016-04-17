//
//  OTMLoginViewController.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit

class OTMLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var debugTextView: UITextView!
    
    var flag = false
    
    var defaultColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultColor = view.backgroundColor
        userIDTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        enableUI(true)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginPressed(sender: UIButton) {
    
        let udacitySharedInstance = UdacityLogin.sharedUdacityInstance()
        
        if passwordTextField.text != "" && userIDTextField.text != "" {
            enableUI(false)
            udacitySharedInstance.authAndFetch(userIDTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            
                if success {
                    performUIUpdatesOnMain() {
                        self.enableUI(true)
                        self.completeLogin()
                    }
                } else {
                    if errorString == errorStrings.invalidCredentials || errorString == errorStrings.cantFetchParse || errorString == errorStrings.cantLoginUdacity {
                        performUIUpdatesOnMain() {
                            self.enableUI(true)
                            createAlert(self, error: errorString!)
                        }
                    } else {
                        performUIUpdatesOnMain() {
                            self.enableUI(true)
                            self.debugTextView.text = errorString
                        }
                    }
                }
            }
        } else {
            createAlert(self, error: errorStrings.noIDPassword)
        }
    
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("mapListNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    func enableUI(enable: Bool) {
        
        loginButton.enabled = enable
        activityView.hidden = enable
        userIDTextField.enabled = enable
        passwordTextField.enabled = enable
        signUpButton.enabled = enable
        
        if enable {
            activityView.stopAnimating()
            stackView.alpha = 1.0
            view.backgroundColor = defaultColor
        } else {
            activityView.startAnimating()
            stackView.alpha = 0.5
            view.backgroundColor = UIColor.grayColor()
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (userIDTextField.editing || passwordTextField.editing) && view.frame.origin.y == 0{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
}