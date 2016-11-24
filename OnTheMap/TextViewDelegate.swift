//
//  TextViewDelegate.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/24/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
