//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/14/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    
    static var allStudentInformation: [StudentInformation] = []
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: CLLocationDegrees = CLLocationDegrees()
    var longitude: CLLocationDegrees = CLLocationDegrees()
    
    /* Initial a student information from dictionary */
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary[OTMClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.UniqueKey] as! String
        mapString = dictionary[OTMClient.JSONResponseKeys.MapString] as! String
        
        firstName = dictionary[OTMClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[OTMClient.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[OTMClient.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[OTMClient.JSONResponseKeys.MediaUrl] as! String
        
    }
    
    /* Convert an array of dictionaries to an array of student information struct objects */
    static func convertFromDictionaries(array: [[String : AnyObject]]) -> [StudentInformation] {
        var resultArray = [StudentInformation]()
        
        for dictionary in array {
            resultArray.append(StudentInformation(dictionary: dictionary))
        }
        
        return resultArray
    }
}
