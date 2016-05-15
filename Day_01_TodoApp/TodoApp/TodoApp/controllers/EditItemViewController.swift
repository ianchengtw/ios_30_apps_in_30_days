//
//  EditItemViewController.swift
//  TodoApp
//
//  Created by Ian on 5/7/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    var todoItem: TodoItem = TodoItem(id: 0, title: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleInput.text = todoItem.title
        self.titleInput.becomeFirstResponder()
        
        self.descriptionInput.text = todoItem.description
        
        self.btnSave.layer.cornerRadius = 5
        self.btnSave.layer.borderWidth = 1
        self.btnSave.layer.borderColor = UIColor.blueColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteItem(sender: UIBarButtonItem) {
        
        todoItemModel.removeTodoItem(self.todoItem)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func saveItem(sender: UIButton) {
        
        self.todoItem.title = titleInput.text ?? ""
        self.todoItem.description = descriptionInput.text ?? ""
        
        todoItemModel.updateTodoItem(self.todoItem)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
