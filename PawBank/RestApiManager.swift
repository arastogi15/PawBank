//
//  RestApiManager.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/18/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import Foundation

//
//typealias ServiceResponse = (JSON, NSError?) -> Void
//
//class RestApiManager: NSObject {
//    static let sharedInstance = RestApiManager()
//    
//    let baseURL = "http://api.randomuser.me/"
//    
//    func getRandomUser(onCompletion: (JSON) -> Void) {
//        let route = baseURL
//        makeHTTPGetRequest(route, onCompletion: { json, err in
//            onCompletion(json as JSON)
//        })
//    }
//    
//    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
//        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
//        
//        let session = NSURLSession.sharedSession()
//        
//        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            let json:JSON = JSON(data: data)
//            onCompletion(json, error)
//        })
//        task.resume()
//    }
//}
