//
//  RootTableViewController.swift
//  MZRealmManager
//
//  Created by muzcity on 2017. 6. 22..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import RealmSwift
import MZRealmManager

class RootTableViewController: UITableViewController {
    
    
    var manager : MZRealmManager!
    var items : Results<Foo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = MZRealmManager()
        
        items = manager.filter(Foo.self, query: "")
        
        manager.addNotifications(items) { [weak self] (obj, deletions, insertions, modifications) in
            self?.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let f = items[indexPath.row]
        cell.textLabel?.text = f.name
        cell.detailTextLabel?.text = "\(f.time)" //"\(f.firstName)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let obj = items[indexPath.row]
        manager.remove(object: obj)
        
    }
    
    @IBAction func addFoo(sender:AnyObject) {
        let f = Foo()
        f.name = "muzcity"
        f.time = 23
        
        manager.asyncAdd(object: f)
    }
    
}
