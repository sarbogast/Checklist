//
//  ViewController.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 26/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var dataModel:DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel = DataModel.sharedModel
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem(item: Checklist) {
        dataModel.lists.append(item)
        
        let indexPath = NSIndexPath(forRow: dataModel.lists.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.viewControllers[0] as? AddItemViewController {
                    addItemViewController.addItemViewControllerDelegate = self
                }
            }
        } else if segue.identifier == "editItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.viewControllers[0] as? AddItemViewController {
                    if let checklist = sender as? Checklist {
                        addItemViewController.addItemViewControllerDelegate = self
                        addItemViewController.checklistToEdit = checklist
                    }
                }
            }
        } else if segue.identifier == "showListSegue" {
            if let todoListViewController = segue.destinationViewController as? TodoListViewController {
                if let checklist = sender as? Checklist {
                    todoListViewController.todoListViewControllerDelegate = self
                    todoListViewController.todoList = checklist
                }
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
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: Checklist) {
        
        if let index = dataModel.lists.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension ChecklistViewController { //: UITableViewDataSource {
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let checklist = self.dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.title
        if checklist.todos.count > 0 && checklist.numberOfUndoneTodos() == 0 {
            cell.detailTextLabel!.text = "C'est fait!"
        } else {
            cell.detailTextLabel?.text = "(\(checklist.todos.count) tâches dont \(checklist.numberOfUndoneTodos()) non-terminées)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

//UITableViewDelegate implementation
extension ChecklistViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showListSegue", sender: self.dataModel.lists[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("editItemSegue", sender: self.dataModel.lists[indexPath.row])
    }
}

extension ChecklistViewController: TodoListViewControllerDelegate {
    func todoListViewController(controller:TodoListViewController, didChangeTodoList:Checklist) {

    }
}

