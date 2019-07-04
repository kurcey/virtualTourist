//
//  getLocations.swift
//  OnTheMap
//
//  Created by user152630 on 6/13/19.
//  Copyright © 2019 user152630. All rights reserved.
//
import Foundation
import UIKit

class APIClient{
    let networkHelper = Network()
    let converter = Converter()
    let api = Constants.ApiCall()
    let studentLocation = Constants.studentLocation()
    let constants = Constants()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getLocation(_ limit: Int?, _ skip: Int?, _ order : String?, _ uniqueKey: String?, _ callbackFunc: @escaping (_ data: URLResponse?,_ result: AnyObject?,_ error: NSError?)->Void) {
        
        let limitPassed = limit ?? 1
        let skipPassed = skip ?? 1
        let orderPassed = order ?? ""
        let uniqueKeyPasssed = uniqueKey ?? ""
        
        let passedParameters = ["limit" : limitPassed,
                                "skip" : skipPassed,
                                "order" : orderPassed,
                                "uniqueKey" : uniqueKeyPasssed] as [String : AnyObject]
        let passedMethod = api.getAPIMultipleStudentLocations
        
        networkHelper.taskForGETMethod(passedMethod , parameters: passedParameters, completionHandlerForGET: callbackFunc)
    }
    
    
    func logInApi(userName: String?, password: String?, _ callbackFunc: @escaping (_ data: URLResponse?,_ result: AnyObject?,_ error: NSError?)->Void) {
        do {
            let loginMethod = api.postAPISession
            let passedParameters = [:] as [String : AnyObject]
            
            let passedBody = ["username" : userName, "password" : password ] as! [String : String]
            
            let udacityPreamble = ["udacity": passedBody] as [String : AnyObject]
            let str = try JSONSerialization.data(withJSONObject: udacityPreamble, options: .prettyPrinted)
            let body = String(decoding: str, as: UTF8.self)
            
            networkHelper.taskForPOST_PUT_DELETEMethod("POST",loginMethod, parameters: passedParameters , jsonBody: body, completionHandler: callbackFunc)
        }
        catch {
            print("Error sending Json login text")
        }
    }
    
    func logOutApi(_ callbackFunc: @escaping (_ data: URLResponse?,_ result: AnyObject?,_ error: NSError?)->Void) {
        
        let passedParameters = [:] as [String : AnyObject]
        let passedMethod = api.postAPISession
        networkHelper.taskForPOST_PUT_DELETEMethod("DELETE",passedMethod , parameters: passedParameters, jsonBody: "", completionHandler: callbackFunc)
    }
    
    func getUserInfo(_ userKey : String) {
        let passedParameters = [:] as [String : AnyObject]
        let passedMethod = api.getAPIPublicUserData
        networkHelper.taskForGETMethod(passedMethod+"/"+userKey, parameters: passedParameters, completionHandlerForGET: saveUserInfo )
    }
    
    func savePin(_ location : String?, _ mediaURL : String?,_ lattitude : String?, _ longitude : String?,_ callbackFunc: @escaping (_ data: URLResponse?,_ result: AnyObject?,_ error: NSError?)->Void) {
        do{
            let passedParemeters = [:] as [String : AnyObject]
            
            let presentLocaion = location ?? ""
            let presentMediaURL = mediaURL ?? ""
            let presentLattitude = (lattitude! as NSString).floatValue
            let presentLongitude = (longitude! as NSString).floatValue
            
            let key = SavedInfo.userInformation.key ?? ""
            let first_name = SavedInfo.userInformation.first_name  ?? ""
            let last_name = SavedInfo.userInformation.last_name ?? ""
            
            let sentInfo = [ "uniqueKey" : key,
                             "firstName" : first_name,
                             "lastName": last_name,
                             "mapString": presentLocaion,
                             "mediaURL": presentMediaURL,
                             "latitude": presentLattitude,
                             "longitude": presentLongitude
                ] as [String : AnyObject]
            
            let str = try JSONSerialization.data(withJSONObject: sentInfo, options: .prettyPrinted)
            let body = String(decoding: str, as: UTF8.self)
            let passedMethod = api.postAPIStudentLocations
            
            networkHelper.taskForPOST_PUT_DELETEMethod("POST",passedMethod , parameters: passedParemeters, jsonBody: body, completionHandler: callbackFunc)
        }
        catch{
            print ("Error trying to send data to Server")
            callbackFunc(nil,nil,error as NSError)
        }
    }
    
    func saveSession( sessionData : Data){
        
        let sessionData = String(data: sessionData, encoding: .utf8)!
        do {
            let result = try JSONDecoder().decode(
                Constants.loginSession.self, from: sessionData.data(using: .utf8)!)
            
            SavedInfo.savedSession = result.session.id
            SavedInfo.userInformation.key = result.account.key
            getUserInfo(result.account.key)
        }
        catch {
            print(error)
        }
    }
    
    func saveUserInfo (_ data: URLResponse?,_ result: AnyObject?,_ error: NSError?)->Void{
        if (result != nil){
            let convertData = result as! Data
            let range = (5..<convertData.count)
            let newData = convertData.subdata(in: range)
            let userInfo = converter.convertUserInfo(newData as AnyObject)
            SavedInfo.userInformation = userInfo!
        }
        else{
            print("Error getting user info: \(String(describing: error))")
        }
    }
}
