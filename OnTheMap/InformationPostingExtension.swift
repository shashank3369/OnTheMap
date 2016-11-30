//
//  InformationPostingExtension.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/24/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import UIKit

extension InformationPostingViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if locationTextView.isFirstResponder {
            view.frame.origin.y =  -view.frame.height/4
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func prepareTextView() {
        locationTextView.delegate = textViewDelegate
        linkTextView.delegate = textViewDelegate
        locationTextView.text = "Please enter a location."
        linkTextView.text = "Please enter a link."
        
    }
    
}
