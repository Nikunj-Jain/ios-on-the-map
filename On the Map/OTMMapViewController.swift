//
//  OTMMapViewController.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OTMMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    var annotations = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpMap", name: NSNotificationCenterKeys.successfulKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if var toOpen = view.annotation?.subtitle! {
                toOpen = toOpen.lowercaseString
                if (!toOpen.containsString("http://") && !toOpen.containsString("https://")){
                    toOpen = "http://\(toOpen)"
                }
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    func setUpMap() {

        let localStudentsArray = studentsArray
        mapView.removeAnnotations(annotations)
        
        for dictionary in localStudentsArray {
            
            let student = Student(studentDictionary: dictionary)
            
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.getName()
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        mapView.delegate = self
    }
    
}