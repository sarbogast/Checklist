//
//  ViewController.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 26/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    let checklistsKey = "checklists"
    var dataModel = [Checklist]()
    //var indexPathToEdit: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Data file path: \(dataFilePath())")
        loadChecklists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem(item: Checklist) {
        dataModel.append(item)
        
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    
                    addItemViewController.addItemViewControllerDelegate = self
                    
                }
            }
        } else if segue.identifier == "editItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                        addItemViewController.addItemViewControllerDelegate = self
                        addItemViewController.checklistToEdit = dataModel[indexPath.row]
                    }
                }
            }
        } else if segue.identifier == "showList" {
            if let todoListViewController = segue.destinationViewController as? TodoListViewController {
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                    todoListViewController.todoListViewControllerDelegate = self
                    todoListViewController.todoList = dataModel[indexPath.row]
                }
            }
        }
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(dataModel, forKey: checklistsKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                defer {
                    unarchiver.finishDecoding()
                }
                self.dataModel = unarchiver.decodeObjectForKey(checklistsKey) as! [Checklist]
                //unarchiver.finishDecoding()
            }
        }
    }
}

extension ChecklistViewController : AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: Checklist) {
        addItem(item)
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        saveChecklists()
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: Checklist) {
        
        if let index = dataModel.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        saveChecklists()
    }
}

extension ChecklistViewController { //: UITableViewDataSource {
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        let checklist = self.dataModel[indexPath.row]
        label.text = checklist.title
        //cell.accessoryType = checklist.done ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        saveChecklists()
    }
}

extension ChecklistViewController: TodoListViewControllerDelegate {
    func todoListViewController(controller:TodoListViewController, didChangeTodoList:Checklist) {
        saveChecklists()
    }
}

