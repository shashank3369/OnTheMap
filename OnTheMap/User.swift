//
//  User.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/18/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import MapKit

class User: NSObject {
    
    var userId: String?
    var firstName: String?
    var lastName: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var mapString: String?
    var mediaURL: String?
    
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
