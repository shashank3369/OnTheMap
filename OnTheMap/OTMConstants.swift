//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/13/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import UIKit

extension OTMClient {
    struct JSONResponseKeys {
        // MARK: StudentInformation
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let ObjectID = "objectID"
        static let UniqueKey = "uniqueKey"
        static let Results = "results"
    }
    
    struct ParameterKeys {
        static let ApplicationID = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    }
    
    struct ParameterValues {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let StudentsURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
}
