//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/18/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {

    var firstName: String?
    var lastName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBackToListOrMap))
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        OTMClient.sharedInstance().getUserData { (firstName, lastName, error) in
            if (error == nil) {
                self.firstName = firstName
                self.lastName = lastName
            }
        }
    }
    
    func goBackToListOrMap() {
        if (self.presentingViewController?.isKind(of: MapViewController.self))! {
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
