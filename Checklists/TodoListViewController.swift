//
//  TodoListViewController.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 30/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

protocol TodoListViewControllerDelegate: class {
    func todoListViewController(controller:TodoListViewController, didChangeTodoList:Checklist)
}

class TodoListViewController: UITableViewController {
    weak var todoListViewControllerDelegate:TodoListViewControllerDelegate?
    
    var todoList:Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = todoList.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createTodoSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController, todoViewController = navigationController.topViewController as? TodoViewController {
                todoViewController.todoViewControllerDelegate = self
            }
        } else if segue.identifier == "editTodoSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController, todoViewController = navigationController.topViewController as? TodoViewController {
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    todoViewController.todoViewControllerDelegate = self
                    todoViewController.todo = self.todoList.todos[indexPath.row]
                }
            }
        }
    }
}

//UITableViewDataSource implementation
extension TodoListViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.todos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath)
        
        let todo = todoList.todos[indexPath.row]
        let doneLabel = cell.viewWithTag(1000) as! UILabel
        doneLabel.text = todo.done ? "✅" : ""
        let titleLabel = cell.viewWithTag(1001) as! UILabel
        titleLabel.text = todo.title
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.todoList.todos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

//UITableViewDelegate implementation
extension TodoListViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = self.todoList.todos[indexPath.row]
        todo.done = !todo.done
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
}

extension TodoListViewController: TodoViewControllerDelegate {
    func todoViewControllerDidCancel(todoViewController: TodoViewController) {
        todoViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func todoViewController(todoViewController: TodoViewController, didFinishCreatingTodo todo: Todo) {
        self.todoList.todos.append(todo)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:self.todoList.todos.count - 1, inSection:0)], withRowAnimation: .Automatic)
        if let todoListViewControllerDelegate = self.todoListViewControllerDelegate {
            todoListViewControllerDelegate.todoListViewController(self, didChangeTodoList: self.todoList)
        }
        todoViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func todoViewController(todoViewController: TodoViewController, didFinishEditingTodo todo: Todo) {
        if let index = self.todoList.todos.indexOf(todo) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            if let todoListViewControllerDelegate = self.todoListViewControllerDelegate {
                todoListViewControllerDelegate.todoListViewController(self, didChangeTodoList: self.todoList)
            }
            todoViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
