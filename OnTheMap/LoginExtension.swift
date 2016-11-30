//
//  LoginExtension.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/20/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 1 && !(textField.text?.isEmpty)!) {
            loginWithUdacity(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height-30
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
            view.frame.origin.y =  -getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}
