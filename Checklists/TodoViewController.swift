//
//  TodoViewController.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 30/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import UIKit

protocol TodoViewControllerDelegate: class {
    func todoViewControllerDidCancel(todoViewController:TodoViewController)
    func todoViewController(todoViewController: TodoViewController, didFinishCreatingTodo: Todo)
    func todoViewController(todoViewController: TodoViewController, didFinishEditingTodo: Todo)
}

class TodoViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var todoViewControllerDelegate: TodoViewControllerDelegate?
    
    var todo:Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = self.todo {
            self.title = "Modifier un todo"
            self.titleField.text = todo.title
        } else {
            self.title = "Créer un todo"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.titleField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done(sender: AnyObject) {
        if let title = self.titleField.text {
            let trimmedText = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if trimmedText.characters.count == 0 {
                let alert = UIAlertController(title: "Erreur", message: "Le titre ne peut pas être vide", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                presentViewController(alert, animated: true, completion: nil)
            } else {
                if let todoViewControllerDelegate = self.todoViewControllerDelegate {
                    if let todo = self.todo {
                        todo.title = trimmedText
                        todoViewControllerDelegate.todoViewController(self, didFinishEditingTodo: todo)
                    } else {
                        let todo = Todo(withTitle: trimmedText)
                        todoViewControllerDelegate.todoViewController(self, didFinishCreatingTodo: todo)
                    }
                }
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if let todoViewControllerDelegate = self.todoViewControllerDelegate {
            todoViewControllerDelegate.todoViewControllerDidCancel(self)
        }
    }
    
}

extension TodoViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let newText = (oldText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        doneButton.enabled = newText.characters.count > 0
        return true
    }
}