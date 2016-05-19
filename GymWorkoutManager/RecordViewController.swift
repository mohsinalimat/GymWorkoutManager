//
//  RecordViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UITableViewController {
    // MARK: - Variables
    var totalRecord = ["1","2","3"]
    var result : Results<Exercise>!
    var curentUser:Person?
    
    func addRecord(item:String, time:String){
        let item = ""
        let time = ""
        totalRecord.append("you have been doing\n\(item)\n\(time)")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return result.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let infoCell = self.tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath) as! RecordInfoCell
            let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
            curentUser = cusers?.first
            if curentUser == nil {
                curentUser = Person()
            }
            
            if let user = curentUser {
                DatabaseHelper.sharedInstance.beginTransaction()
                infoCell.activeDay.text = "\(user.activedDays)"
                infoCell.name.text = user.name
                infoCell.weight.text = user.weight
                if let pictureData = user.profilePicture {
                    infoCell.profileImage.image = UIImage(data: pictureData)
                }
                DatabaseHelper.sharedInstance.commitTransaction()
            }
            infoCell.effectiveIndex.text = "0.3"
            return infoCell
            
        } else {
            let recordCell = self.tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            let content = result[indexPath.row]
            // TODO: correct content text
            recordCell.textLabel?.text = "\(content.date)---\(content.exerciseName) \(content.reps) reps \(content.set) sets "
            recordCell.textLabel?.textColor = recordCell.tintColor
            recordCell.textLabel?.numberOfLines = totalRecord[indexPath.row].characters.count
            return recordCell
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    //Todo: delete issue
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(result[indexPath.row])
                }
            } catch let error as NSError {
                print(error)
                // TODO: need an error handling API
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 183
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Records"
        self.edgesForExtendedLayout=UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        do {
            let r = try Realm()
            result = r.objects(Exercise)
            tableView.reloadData()
        } catch {
            print("loading realm faild")
        }
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(editTable))
    }
    func editTable() {
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

