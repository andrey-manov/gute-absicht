//
//  VehiclesListVC.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 22/08/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import UIKit

class VehiclesListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var vehiclesTable: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var vehiclesList = [Vehicle]()
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = false
        vehiclesTable.hidden = true
        errorLbl.hidden = true
        
        let ad = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let nl = ad.networkLayer
        
        let completion = {(vehList: [Vehicle]?, error: NSError?) in
            if error != nil {
                self.activityIndicator.hidden = true
                self.errorLbl.hidden = false
            }
            else {
                self.vehiclesList = vehList!
                self.vehiclesTable.reloadData()
                
                self.activityIndicator.hidden = true
                self.vehiclesTable.hidden = false
                self.errorLbl.hidden = true
            }
        }
        
        nl.requestVehicles(nil, completion: completion)
    }
    
    // MARK: - Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehiclesList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
        }
        
        let v = vehiclesList[indexPath.row]
        cell!.textLabel?.text = v.name;
        
        return cell!
        
    }
}
