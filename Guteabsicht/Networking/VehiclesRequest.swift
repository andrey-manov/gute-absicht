//
//  VehiclesRequest.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 05/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import Foundation
import UIKit

class VehiclesRequest : NSObject {
    
    var dataTask: NSURLSessionDataTask? = nil
    
    init(session: NSURLSession, commonComponents components: NSURLComponents, tankId: Int?, completion:([Vehicle]?, NSError?) -> Void) {
        
        super.init()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        //        let searchTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!
        

        components.path = "/wotb/encyclopedia/vehicles/"
        var qI : [NSURLQueryItem] = components.queryItems!
        
//        qI.append(NSURLQueryItem(name:"fields", value:"tank_id name guns"))
        if let ti = tankId {
            qI.append(NSURLQueryItem(name:"tank_id", value:String(ti)))
        }
        
        let url = components.URL
        
        print("\(components.string)")
        
        //        https://api.wotblitz.ru/wotb/encyclopedia/vehicles/?application_id=demo&fields=tank_id%2C%20name%2C%20guns&tank_id=1
        
        
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
    func parseResults(data: NSData?) throws -> [Vehicle]? {

        if let data = data {
            let str = String(data:data, encoding:NSUTF8StringEncoding)
            print("\(str)")
            
            if let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let data = jsonData["data"] as? NSDictionary {
                    
                    var vehiclesList:[Vehicle] = []
                    
                    for (_,vehicleDictionary) in data {
                        
                        if let vehicleDictionary = vehicleDictionary as? [String: AnyObject] {
                            
                            let v = Vehicle()
                            
                            v.name = vehicleDictionary["name"] as? String
                            v.tank_id = vehicleDictionary["tank_id"] as? Int
                            vehiclesList.append(v)
                        } else {
                            print("Not a dictionary")
                        }
                    }
                    
                    return vehiclesList
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