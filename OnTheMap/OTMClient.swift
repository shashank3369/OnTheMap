//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/13/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import Foundation
import UIKit

class OTMClient: NSObject {
    // shared session
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    func taskForPOSTMethod(_ username: String, _ password: String, completionHandlerForPOST: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")! )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(false, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
    }

    func getStudentInfo(completionHandlerForGet: @escaping (_ studentInfo: [StudentInformation]?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(OTMClient.Constants.StudentsURL)?limit=100")!)
        request.addValue(OTMClient.ParameterValues.ApplicationID, forHTTPHeaderField: OTMClient.ParameterKeys.ApplicationID)
        request.addValue(OTMClient.ParameterValues.ApiKey, forHTTPHeaderField: OTMClient.ParameterKeys.ApiKey)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else { // Handle error...
                completionHandlerForGet(nil, error as NSError?)
                return
            }
            
            let resultString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let result = self.convertStringToDictionary(text: (resultString as String))
            guard let studentsInformation = result?["results"] as? [[String: AnyObject]] else {
                completionHandlerForGet(nil, error as NSError?)
                return
            }
            
            StudentInformation.allStudentInformation = StudentInformation.convertFromDictionaries(array: studentsInformation)
            completionHandlerForGet(StudentInformation.allStudentInformation, nil)
        }
        task.resume()
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ success: Bool, _ error: NSError?) -> Void) {
        
        let dataLength = data.count
        let r = 5...Int(dataLength)
        let newData = data.subdata(in: Range(r)) /* subset response data! */
        let resultString = NSString(data: newData, encoding: String.Encoding.utf8.rawValue)
        let result = convertStringToDictionary(text: resultString as! String)
        guard (result?["status"]) != nil else {
            completionHandlerForConvertData(true, nil)
            return
        }
        completionHandlerForConvertData(false, nil)
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}
