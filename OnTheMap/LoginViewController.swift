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
        // Do any additional setup after loading the view, typically from a nib.
        configureBackground()
        loginActivityIndicator.hidesWhenStopped = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginActivityIndicator.stopAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginWithUdacity(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginActivityIndicator.startAnimating()
            OTMClient.sharedInstance().taskForPOSTMethod(email, password) {(success, error) in
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
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}

private extension LoginViewController {
    func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.925, green: 0.435, blue: 0.4, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.953, green: 0.631, blue: 0.514, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.frame = view.bounds
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    func displayAlert(_ errorString: String) {
        let alertController = UIAlertController(title: "Message", message: errorString, preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.loginActivityIndicator.stopAnimating()
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

