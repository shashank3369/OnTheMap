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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        activityIndicator.hidesWhenStopped = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        OTMClient.sharedInstance().getUserData { (firstName, lastName, error) in
            if (error == nil) {
                self.firstName = firstName
                self.lastName = lastName
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkLocation(_ sender: Any) {
        activityIndicator.startAnimating()
        if (locationTextView.text.characters.count != 0) {
        CLGeocoder().geocodeAddressString(locationTextView.text, completionHandler: { (placemarks, error) in
                if error != nil {
                    self.activityIndicator.stopAnimating()
                    self.showError(errorString: "Not able to geocode address string. Please enter another one.")
                    return
                }
                if (placemarks?.count)! > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    User.sharedInstance().latitude = coordinate?.latitude
                    User.sharedInstance().longitude = coordinate?.longitude
                    User.sharedInstance().mapString = self.locationTextView.text
                    self.centerOnLocation(coordinate!)
                    self.activityIndicator.stopAnimating()
                    self.linkTextView.isHidden = false
                    self.mapView.isHidden = false
                    self.submitButton.isHidden = false
                    self.bottomView.isHidden = true
                    self.questionLabel.isHidden = true
                    
                }
            })
        }
        else {
            showError(errorString: "Please enter a location")
        }
    }

    func centerOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = coordinate
        mapView.addAnnotation(userAnnotation)
        mapView.setRegion(region, animated: true)
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
    
    @IBAction func postToWS(_ sender: Any) {
        if (linkTextView.text.characters.count != 0) {
            User.sharedInstance().mediaURL = linkTextView.text
            User.sharedInstance().firstName = self.firstName
            User.sharedInstance().lastName = self.lastName
            OTMClient.sharedInstance().postStudentLocation { (success, error) in
                guard error == nil else {
                    self.showError(errorString: "Wasn't able to post your information")
                    return
                }
                if (success)! {
                    self.goBack(self)
                }
            }
        }
        else {
            showError(errorString: "Please enter a URL")
        }
    }
    
    func showError(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
