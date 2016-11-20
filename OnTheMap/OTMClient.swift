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
    var user = User.sharedInstance()
    override init() {
        super.init()
    }
    
    // MARK: POST
    func login(_ username: String, _ password: String, completionHandlerForPOST: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
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
            
            self.convertLoginDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
    }

    func deleteSession(completionHandlerForDelete: @escaping (_ success: Bool?, _ error: NSError?)->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForDelete(nil, error as? NSError)
                return
            }
            completionHandlerForDelete(true, nil)
        }
        task.resume()
    }
    
    
    func getStudentInfo(completionHandlerForGet: @escaping (_ studentInfo: [StudentInformation]?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "\(OTMClient.Constants.StudentsURL)?limit=100&order=-updatedAt")!)
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
    
    private func convertLoginDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ success: Bool, _ error: NSError?) -> Void) {
        
        let dataLength = data.count
        let r = 5...Int(dataLength)
        let newData = data.subdata(in: Range(r)) /* subset response data! */
        let resultString = NSString(data: newData, encoding: String.Encoding.utf8.rawValue)
        let result = convertStringToDictionary(text: resultString as! String)
        guard (result?["status"]) == nil else {
            completionHandlerForConvertData(false, nil)
            return
        }
        guard let userInfo = result?["account"] as? [String: AnyObject] else {
            completionHandlerForConvertData(false,nil)
            return
        }
        if let userID = userInfo["key"] as? String  {
            User.sharedInstance().userId = userID
        }else {
            completionHandlerForConvertData(false,nil)
            return
        }
        completionHandlerForConvertData(true, nil)
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
    
    func getUserData(completionHandlerForGet: @escaping (_ firstName: String?, _ lastName: String?, _ error: NSError?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(User.sharedInstance().userId!)")!)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            let resultString = NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!
            let result = self.convertStringToDictionary(text: resultString as String)
            if let userInfo = result?["user"] as? [String: AnyObject]{
                if let firstName = userInfo["first"] as? String, let lastName = userInfo["last"] as? String {
                        completionHandlerForGet(firstName, lastName, nil)
                }
                else {
                    completionHandlerForGet(nil,nil,error as NSError?)
                }
            }else {
                completionHandlerForGet(nil,nil,error as NSError?)
            }
        }
        task.resume()
    }
    
    
    func postStudentLocation(completionHandlerForPost: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(OTMClient.ParameterValues.ApplicationID, forHTTPHeaderField: OTMClient.ParameterKeys.ApplicationID)
        request.addValue(OTMClient.ParameterValues.ApiKey, forHTTPHeaderField: OTMClient.ParameterKeys.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \(user.userId), \"firstName\": \(user.firstName), \"lastName\": \(user.lastName),\"mapString\": \(user.mapString), \"mediaURL\": \(user.mediaURL),\"latitude\": \(user.latitude), \"longitude\": \(user.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPost(false, error as? NSError)
                return
            }
            completionHandlerForPost(true, nil)
        }
        task.resume()
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
