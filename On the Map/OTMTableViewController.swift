//
//  OTMTableViewController.swift
//  On the Map
//
//  Created by Nikunj Jain on 16/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation
import UIKit

class OTMTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let localStudentsArray = studentsArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable", name: NSNotificationCenterKeys.successfulKey, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localStudentsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell")! 
        let student = Student(studentDictionary: studentsArray[indexPath.row])
        
        cell.imageView?.image = UIImage(named: "Pin")
        cell.textLabel?.text = student.getName()
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = Student(studentDictionary: studentsArray[indexPath.row])
        guard var url = student.mediaURL else {
            return
        }
        url = url.lowercaseString
        if (!url.containsString("http://") && !url.containsString("https://")){
            url = "http://\(url)"
        }
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
}