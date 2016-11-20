//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/14/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var studentList: [StudentInformation]?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        setupNavBar()
    }

    func setupNavBar() {
        self.parent?.navigationItem.hidesBackButton = true
        self.parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        let newStudent = UIBarButtonItem(image: UIImage(named: "pin"), style: .plain, target: self, action: #selector(addStudent))
        self.parent?.navigationItem.setRightBarButtonItems([refreshButton,newStudent], animated: false)
        self.parent?.navigationItem.title = "On The Map"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                self.showError(errorString: "Not able to load studnet information")
                return
            }
            self.studentList = studentInfo
            self.loadAnnotations(self.studentList!)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func loadAnnotations(_ studentInfo: [StudentInformation]) {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        var annotations = [MKPointAnnotation]()
        for student in studentInfo {
            
            let annotation = MKPointAnnotation()
            if let lat = student.latitude, let long = student.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.coordinate = coordinate
            }
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
           
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func logout () {
        OTMClient.sharedInstance().deleteSession { (success, error) in
            guard error == nil else {
                self.showError(errorString: "Not able to logout")
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        }
    }
    
    func reload() {
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                self.showError(errorString: "Having trouble refreshing student information.")
                return
            }
            self.studentList = studentInfo
            self.loadAnnotations(self.studentList!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addStudentInfoFromMap" {
            let destinationNav = segue.destination as! UINavigationController
            let destinationVC = destinationNav.topViewController as! InformationPostingViewController
            destinationVC.identifiyingProperty = "map"
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
    
    func addStudent() {
        self.performSegue(withIdentifier: "addStudentInfoFromMap", sender: self)
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {}
}
