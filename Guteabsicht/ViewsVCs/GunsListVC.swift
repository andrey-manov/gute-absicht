//
//  GunsListVC.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 23/08/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import UIKit

class GunsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gunsTable: UITableView!
    
    var gunsList = [Gun]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        gunsList = [Gun]()
    }

    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = false
        gunsTable.hidden = true
        errorLbl.hidden = true
        
        let ad = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let nl = ad.networkLayer
        
        let completion = {(gunsList: [Gun]?, error: NSError?) in
            if error != nil {
                self.activityIndicator.hidden = true
                self.errorLbl.hidden = false
            }
            else {
                self.gunsList = gunsList!
                self.gunsTable.reloadData()
                
                self.activityIndicator.hidden = true
                self.gunsTable.hidden = false
                self.errorLbl.hidden = true
            }
        }
        
        nl.requestGuns(nil, completion: completion)
    }
    
    // MARK: - Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gunsList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
        }
        
        let v = gunsList[indexPath.row]
        cell!.textLabel?.text = v.name;
        
        return cell!
        
    }
}
