//
//  User.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/18/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation


class User: NSObject {
    
    var userId: String?
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> User {
        struct Singleton {
            static var sharedInstance = User()
        }
        return Singleton.sharedInstance
    }
}
