//
//  NewItemViewController.swift
//  TodoApp
//
//  Created by Ian on 5/7/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleInput.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveItem(sender: UIBarButtonItem) {
        
        let title = titleInput.text ?? ""
        let description = descriptionInput.text ?? ""
        
        todoItemModel.addTodoItem(title: title, description: description)
        
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
