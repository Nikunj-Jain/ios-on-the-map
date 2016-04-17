//
//  StudentCellView.swift
//  On the Map
//
//  Created by Nikunj Jain on 17/03/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import UIKit

class StudentCellView: UITableViewCell {
    
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func setUI(student: Student) {
        pinImageView.image = UIImage(named: "Pin")
        nameLabel.text = student.getName()
        urlLabel.text = student.mediaURL!
    }
}
