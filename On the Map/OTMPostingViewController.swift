//
//  OTMPostingViewController.swift
//  On the Map
//
//  Created by Nikunj Jain on 21/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit
import MapKit

class OTMPostingViewController: UIViewController, UITextFieldDelegate{
    
    let udacitySharedInstance = UdacityLogin.sharedUdacityInstance()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var cancelButton: UIButton!

    var mapString: String!
    var placemark: CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI(false)
        showActivityView(false)
        mediaLinkTextField.delegate = self
        locationTextField.delegate = self
    }
    
    
    @IBAction func cancelPosting(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMap(sender: AnyObject) {
        if locationTextField.text == "" {
            createAlert(self, error: errorStrings.noLocationEntered)
            return
        }
        
        showActivityView(true)
        
        let geocoder = CLGeocoder()
        do {
            geocoder.geocodeAddressString(locationTextField.text!) { (results, error) -> Void in
                if error != nil || results!.isEmpty{
                    performUIUpdatesOnMain{
                        self.showActivityView(false)
                        createAlert(self, error: errorStrings.noGeocodeResult)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.configUI(true)
                        self.mapString = self.locationTextField.text!
                        self.placemark = results![0]
                        currentUser.longitude = self.placemark.location!.coordinate.longitude
                        currentUser.latitude = self.placemark.location!.coordinate.latitude
                        self.mapView.showAnnotations([MKPlacemark(placemark: results![0])], animated: true)
                        self.showActivityView(false)
                    }
                }
            }
        }
    }
    
    @IBAction func submitLocation(sender: UIButton) {
        
        if mediaLinkTextField.text == "" {
            createAlert(self, error: errorStrings.noMediaURLEntered)
            return
        }
        showActivityView(true)
        
        currentUser.mediaURL = mediaLinkTextField.text!
        udacitySharedInstance.getUserData { (success, errorString) -> Void in
            if success {
                self.udacitySharedInstance.postUserData(self.mapString) { (success, errorString) -> Void in
                    if success {
                        performUIUpdatesOnMain {
                            self.showActivityView(false)
                            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("mapListNavigationController") as! UINavigationController
                            self.presentViewController(controller, animated: true, completion: nil)
                        }
                    } else {	
                        performUIUpdatesOnMain {
                            self.showActivityView(false)
                            createAlert(self, error: errorString!)
                        }
                    }
                }
            } else {
                performUIUpdatesOnMain {
                    self.showActivityView(false)
                    createAlert(self, error: errorString!)
                }
            }
        }
        
    }
    
    func configUI(showMap: Bool) {
        if showMap {
            middleView.hidden = true
            mapView.hidden = false
            mediaLinkTextField.hidden = false
            submitButton.hidden = false
            findOnMapButton.hidden = true
            questionLabel.hidden = true
            locationTextField.hidden = true
            locationTextField.enabled = false
        } else {
            middleView.hidden = false
            mapView.hidden = true
            mediaLinkTextField.hidden = true
            submitButton.hidden = true
            findOnMapButton.hidden = false
            questionLabel.hidden = false
            locationTextField.hidden = false
            locationTextField.enabled = true
        }
    }
    
    func showActivityView(shouldShow: Bool) {
        if shouldShow {
            activityView.hidden = false
            activityView.startAnimating()
            findOnMapButton.enabled = false
            submitButton.enabled = false
            cancelButton.enabled = false
            locationTextField.enabled = false
            mediaLinkTextField.enabled = false
            mapView.userInteractionEnabled = false
            mapView.zoomEnabled = false
            mapView.scrollEnabled = false
            middleView.alpha = 0.25
            view.alpha = 0.25
        } else {
            activityView.hidden = true
            activityView.stopAnimating()
            findOnMapButton.enabled = true
            submitButton.enabled = true
            cancelButton.enabled = true
            locationTextField.enabled = true
            mediaLinkTextField.enabled = true
            mapView.userInteractionEnabled = true
            mapView.zoomEnabled = true
            mapView.scrollEnabled = true
            middleView.alpha = 1.0
            view.alpha = 1.0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
