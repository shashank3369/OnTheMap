//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/13/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


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
}

