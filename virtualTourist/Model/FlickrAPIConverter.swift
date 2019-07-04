//
//  JSONConverter.swift
//  OnTheMap
//
//  Created by user152630 on 6/11/19.
//  Copyright © 2019 user152630. All rights reserved.
//

import Foundation

class Converter {
    
    func convertPhotoJSON(_ result: AnyObject?) -> [String] {
        var parsedResult: AnyObject! = nil
        var photoStringArray = [String()]
        do {
            parsedResult = try JSONSerialization.jsonObject(with: result as! Data, options: .allowFragments) as AnyObject
            if let stuff = parsedResult as? [String: Any] {
                if let photo =  stuff["photo"] as? [String: Any]{
                    if let photoURL = photo["url_q"] as? String {
                        photoStringArray.append(photoURL)
                    }
                }
            }
        } catch {
            print("Could not parse the data as JSON: '\(result ?? "" as AnyObject)'")
        }
        print(photoStringArray)
        return photoStringArray
    }
}
