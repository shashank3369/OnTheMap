//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/18/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit
import MapKit
class InformationPostingViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var identifiyingProperty: String?
    var firstName: String?
    var lastName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextView.isHidden = true
        mapView.isHidden = true
        submitButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkLocation(_ sender: Any) {
        linkTextView.isHidden = false
        mapView.isHidden = false
        submitButton.isHidden = false
        bottomView.isHidden = true
        questionLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        OTMClient.sharedInstance().getUserData { (firstName, lastName, error) in
            if (error == nil) {
                self.firstName = firstName
                self.lastName = lastName
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        if identifiyingProperty == "map" {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
            }
        }else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToList", sender: self)
            }
        }
    }
}
