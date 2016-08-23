//
//  VehiclesRequest.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 05/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import Foundation
import UIKit

class GunsRequest : NSObject {
    
    var dataTask: NSURLSessionDataTask? = nil
    
    init(session: NSURLSession, commonComponents components: NSURLComponents, gunId: Int?, completion:([Gun]?, NSError?) -> Void) {
        
        super.init()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        //        let searchTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!
        

        components.path = "/wotb/encyclopedia/modules/"
        var qI : [NSURLQueryItem] = components.queryItems!
        
        if let gi = gunId {
            qI.append(NSURLQueryItem(name:"module_id", value:String(gi)))
            qI.append(NSURLQueryItem(name:"fields", value:"guns"))
        }
        
        let url = components.URL
        
        print("\(components.string)")
        
        dataTask = session.dataTaskWithURL(url!) {
            [unowned self] data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if let error = error {
                
                print(error.localizedDescription)
                completion(nil, error)
                
            } else if let httpResponse = response as? NSHTTPURLResponse {
                
                if httpResponse.statusCode == 200 {
                    do {
                        let vehicles = try self.parseResults(data)
                        completion(vehicles, nil)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func resume() {
        dataTask!.resume()
    }
    
    func cancel() {
        if dataTask != nil {
            dataTask?.cancel()
        }
    }
    
    // This helper method helps parse response JSON NSData into an array of Track objects.
    func parseResults(data: NSData?) throws -> [Gun]? {

        if let data = data {
            let str = String(data:data, encoding:NSUTF8StringEncoding)
            print("\(str)")
            
            if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let data = jsonData["data"] as? NSDictionary {
                    
                    // Get the results array
                    if let guns = data["guns"] as? NSArray {
                    
                        var gunsList:[Gun] = []
                        
                        for gunDictionary in guns {
                            
//                            if let vehicleDictionary = vehicleDictionary as? [String: AnyObject] {
                            
                                let gun = Gun()
                                
                                gun.name = gunDictionary["name"] as? String
                                gun.gun_id = gunDictionary["module_id"] as? Int
                                gunsList.append(gun)
//                            } else {
//                                print("Not a dictionary")
//                            }
                        }
                        
                        return gunsList
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        }
        return nil
    }
}