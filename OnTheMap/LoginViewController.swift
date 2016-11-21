//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/13/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: CredentialTextField!
    @IBOutlet weak var passwordTextField: CredentialTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        configureBackground()
        loginActivityIndicator.hidesWhenStopped = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginActivityIndicator.stopAnimating()
        emailTextField.text = ""
        emailTextField.placeholder = "Email"
        passwordTextField.text = ""
        passwordTextField.placeholder = "Password"
    }

    @IBAction func loginWithUdacity(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginActivityIndicator.startAnimating()
            OTMClient.sharedInstance().login(email, password) {(success, error) in
                guard error == nil else {
                    self.displayAlert("Please make sure you are connected to internet before you proceed.")
                    return
                }
                if (success) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
                else {
                    self.displayAlert("Incorrect Credentials")
                }
            }
        } else {
            displayAlert("Please enter your email and password before clicking login")
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}

