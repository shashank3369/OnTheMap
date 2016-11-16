//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/14/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                print ("failure")
                return
            }
            print (studentInfo)
        }

    }
    

}
