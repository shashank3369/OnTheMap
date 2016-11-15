//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/14/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            if (error == nil && studentInfo == nil) {
                print ("success")
            }
            else {
                print ("failure")
            }
        }

    }
    

}
