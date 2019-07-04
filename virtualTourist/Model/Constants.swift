//
//  Constants.swift
//  OnTheMap
//
//  Created by user152630 on 6/11/19.
//  Copyright © 2019 user152630. All rights reserved.
//

import Foundation

class Constants {
    struct ApiCall{
        var ApiScheme = "https"
        var ApiHost = "onthemap-api.udacity.com"
        var ApiPath = "/v1"
        
        var getAPIMultipleStudentLocations = "/StudentLocation"
        var mutipleStudentLocationKey_Limit = "limit"
        var mutipleStudentLocationKey_Skip = "skip"
        var mutipleStudentLocationKey_order = "order"
        var mutipleStudentLocationKey_unique = "uniqueKey"
        
        var postAPIStudentLocations = "/StudentLocation"
        
        var putAPIStudentLocations = "/StudentLocation"
        
        var postAPISession = "/session"
        
        var getAPIPublicUserData = "/users"
    }
    
    struct userInfo {
        var last_name : String?
        var first_name : String?
        var key : String?
    }
    
    struct studentLocation {
        var objectId : String?
        var uniqueKey : String?
        var firstName : String?
        var lastName : String?
        var mapString : String?
        var mediaURL : String?
        var latitude : NSNumber?
        var longitude : NSNumber?
        var createdAt : String?
        var updatedAt : String?
        var ACL : String?
        init(
            objectId : String? = nil,
            uniqueKey :String? = nil,
            firstName : String? = nil,
            lastName : String? = nil,
            mapString : String? = nil,
            mediaURL : String? = nil,
            latitude : NSNumber? = nil,
            longitude : NSNumber? = nil,
            createdAt : String? = nil,
            updatedAt : String? = nil,
            ACL : String? = nil
            ){
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.firstName = firstName
            self.lastName = lastName
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.latitude = latitude
            self.longitude = longitude
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.ACL = ACL
        }
    }
    
    
    struct account: Codable {
        let registered : BooleanLiteralType
        let key: String
    }
    
    struct session: Codable {
        let id : String
        let expiration: String
    }
    
    struct loginSession: Codable {
        let account: account
        let session : session
    }
    
}
