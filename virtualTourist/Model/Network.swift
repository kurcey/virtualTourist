//
//  Network.swift
//  OnTheMap
//
//  Created by user152630 on 6/11/19.
//  Copyright © 2019 user152630. All rights reserved.
//

import Foundation
import UIKit

class Network : NSObject {
    
    var alertController: UIAlertController?
    var baseMessage: String?
    
    // delete this if shared instance is accepted
    class func sharedInstance() -> Network {
        struct Singleton {
            static var sharedInstance = Network()
        }
        return Singleton.sharedInstance
    }
    
    private func universalGuard(_ data: Data?,_ response: URLResponse?,_ error: Error?) -> String? {
        
        var errorResult : String? = nil
        guard (error == nil) else {
            errorResult = error?.localizedDescription
            return errorResult
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            
            switch  (response as? HTTPURLResponse)?.statusCode {
            case 400:
                errorResult = "Bad Request"
            case 401:
                errorResult = "Invalid Credentials"
            case 403:
                errorResult = "Unauthorized"
            case 405:
                errorResult = "HttpMethod not Allowed"
            case 410:
                errorResult = "URL Changed"
            case 500:
                errorResult = "server Error"
            default:
                errorResult = "I have no idea"
            }
            
            return errorResult
        }
        
        guard data != nil else {
            errorResult = "No data was returned by the request!"
            return errorResult
        }
        return errorResult
    }
    
    func sendError(_ data: Data?, error: String, nameOfDomain domainName: String, completionHandler: @escaping (_ data: URLResponse?,_ result: AnyObject?, _ error: NSError?) -> Void){
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandler(nil, error as AnyObject?, NSError(domain: domainName, code: 1, userInfo: userInfo))
    }
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ data: URLResponse?, _ result: AnyObject?, _ error: NSError?) -> Void) -> Void {
        
        let converter = Converter()
        let parametersWithApiKey = parameters
        let request = NSMutableURLRequest(url: converter.URLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let errorTest = self.universalGuard(data,response,error)
            if let errorTest = errorTest {
                self.sendError(nil, error: errorTest, nameOfDomain: "taskForGETMethod", completionHandler: completionHandlerForGET)
                return
            } else
                if  let data = data {
                    completionHandlerForGET(nil, data as AnyObject, nil)
            }
        }
        
        task.resume()
        
    }
    
    
    // MARK: POST
    
    func taskForPOST_PUT_DELETEMethod(_ httpMethod: String, _ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandler: @escaping (_ data: URLResponse?,_ result: AnyObject?, _ error: NSError?) -> Void) -> Void{
        
        let converter = Converter()
        let parametersWithApiKey = parameters
        //parametersWithApiKey[ParameterKeys.ApiKey] = Constants().ApiKey as AnyObject?
        
        let request = NSMutableURLRequest(url: converter.URLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        print("sending post pin Info \(jsonBody) ")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let errorTest = self.universalGuard(data,response,error)
            if let errorTest = errorTest {
                self.sendError(data, error: errorTest, nameOfDomain: "taskForPOST_PUT_DELETEMethod", completionHandler: completionHandler)
                return
            } else{
                converter.convertPOSTDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandler)
                
            }
        }
        
        task.resume()
        
        // return task
    }
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func showAlertMsg(presentView: UIViewController, title: String, message: String) {
        let alertController: UIAlertController?
        guard (self.alertController == nil) else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.alertController=nil;
        }
        
        alertController!.addAction(cancelAction)
        presentView.present(alertController!, animated: true, completion: nil)
    }
    
}
