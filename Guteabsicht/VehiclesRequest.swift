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
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    func startVehiclesListRequest(completion: (NSData?, NSError?) -> Void) {
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
//        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
//        let searchTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!
        
        let components = NSURLComponents()
        components.scheme = "https"
        components.host = "api.wotblitz.ru"
        components.path = "/wotb/encyclopedia/vehicles/"
        
        var qI: [NSURLQueryItem] = []
        
        qI.append(NSURLQueryItem(name:"application_id", value:"demo"))
//        qI.append(NSURLQueryItem(name:"fields", value:"tank_id name guns"))
        qI.append(NSURLQueryItem(name:"tank_id", value:"1"))

        components.queryItems = qI
        
        let url = components.URL
        
        print("\(components.string)")
        
//        https://api.wotblitz.ru/wotb/encyclopedia/vehicles/?application_id=demo&fields=tank_id%2C%20name%2C%20guns&tank_id=1
        
        
        dataTask = defaultSession.dataTaskWithURL(url!) {
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateSearchResults(data)
                }
            }
        }
        dataTask?.resume()
    }
    
    // This helper method helps parse response JSON NSData into an array of Track objects.
    func updateSearchResults(data: NSData?) {
        do {
            if let data = data {
                let str = String(data:data, encoding:NSUTF8StringEncoding)
                print("\(str)")
            }
            
            
//            if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
//                
//                // Get the results array
//                if let array: AnyObject = response["results"] {
//                    for trackDictonary in array as! [AnyObject] {
//                        if let trackDictonary = trackDictonary as? [String: AnyObject], previewUrl = trackDictonary["previewUrl"] as? String {
//                            // Parse the search result
//                            let name = trackDictonary["trackName"] as? String
//                            let artist = trackDictonary["artistName"] as? String
//                            searchResults.append(Track(name: name, artist: artist, previewUrl: previewUrl))
//                        } else {
//                            print("Not a dictionary")
//                        }
//                    }
//                } else {
//                    print("Results key not found in dictionary")
//                }
//            } else {
//                print("JSON Error")
//            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//            self.tableView.setContentOffset(CGPointZero, animated: false)
//        }
    }
}