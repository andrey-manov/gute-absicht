//
//  NetworkLayer.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 07/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import Foundation

class NetworkLayer : NSObject {
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let commonComponents : NSURLComponents
    var vehiclesRequest : VehiclesRequest? = nil
    
    override init() {
        commonComponents = NSURLComponents()
        commonComponents.scheme = "https"
        commonComponents.host = "api.wotblitz.ru"
        
        var qI: [NSURLQueryItem] = []
        qI.append(NSURLQueryItem(name:"application_id", value:"demo"))
        commonComponents.queryItems = qI;
    }
    
    func requestVehicles(tankId:NSNumber?, completion uicompletion:([Vehicle]?, NSError?) -> Void) {
        
        if vehiclesRequest != nil {
            vehiclesRequest?.cancel()
        }
        
        let completion = {(vehicleList: [Vehicle]?, error: NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                uicompletion(vehicleList, error)
            }
        }
        
        var ti: Int?
        
        ti = tankId?.integerValue
        
        vehiclesRequest = VehiclesRequest(session: defaultSession, commonComponents: commonComponents.copy() as! NSURLComponents, tankId: ti, completion:completion)
        vehiclesRequest?.resume()
    }
}