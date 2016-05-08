//
//  TodoItem.swift
//  TodoApp
//
//  Created by Ian on 5/8/16.
//  Copyright © 2016 ianchengtw_ios_30_apps_in_30_days. All rights reserved.
//

import Foundation

struct TodoItem {
    let id: Int
    var title: String = ""
    var description: String = ""
}

// Singleton plugin
extension TodoItemModel {
    
    private static var _instance: TodoItemModel? = nil
    
    class func getInstance() -> TodoItemModel {
        
        if self._instance == nil {
            
            self._instance = TodoItemModel()
            
        }
        
        return self._instance!
        
    }
    
}

class TodoItemModel
{
    typealias TodoItemList = [Int: TodoItem]
    private var _todoItemCount: Int = 0
    private var _todoItemList = TodoItemList()
    var todoItemList: TodoItemList { return self._todoItemList }
    
    init() {
        
        loadData()
        
    }
    
    private func loadData() {
        
        let data = NSUserDefaults.standardUserDefaults()
        
        guard
            let todoItemCount = data.objectForKey("todoItemCount") as? Int,
            let todoItemList = data.objectForKey("todoItemList") as? NSMutableDictionary
            else { return }
        
        self._todoItemCount = todoItemCount
        self._todoItemList = toggleTodoItemListStoredType(todoItemList)
        
    }
    
    private func saveData() {
        
        let data = NSUserDefaults.standardUserDefaults()
        
        data.removeObjectForKey("todoItemCount")
        data.removeObjectForKey("todoItemList")
        
        data.setObject(self._todoItemCount, forKey: "todoItemCount")
        data.setObject(toggleTodoItemListStoredType(self._todoItemList), forKey: "todoItemList")
        
        data.synchronize()
        
    }
    
    private func toggleTodoItemListStoredType(todoItemList: TodoItemList) -> NSMutableDictionary {
        
        let list = NSMutableDictionary()
        
        for (id, item) in todoItemList {
            
            let data = NSMutableDictionary()
            data.setValue(String(item.id), forKey: "id")
            data.setValue(item.title, forKey: "title")
            data.setValue(item.description, forKey: "description")
            
            list[String(id)] = data
            
        }
        
        return list
        
    }
    
    private func toggleTodoItemListStoredType(todoItemList: NSMutableDictionary) -> TodoItemList {
        
        var list = TodoItemList()
        
        for (_id, _item) in todoItemList {
            
            guard
                let id = _id as? Int,
                let data = _item as? NSMutableDictionary,
                let item_id = data["id"] as? Int,
                let title = data["title"] as? String,
                let description = data["description"] as? String
                else { continue }
            
            list[id] = TodoItem(id: item_id, title: title, description: description)
            
        }
        
        return list
        
    }
    
    func addTodoItem(title title: String, description: String) {
        
        self._todoItemCount += 1
        let id = self._todoItemCount
        self._todoItemList[id] = TodoItem(id: id, title: title, description: description)
        
        saveData()
        
    }
    
    func updateTodoItem(todoItem: TodoItem) {
        
        if let _ = self._todoItemList[todoItem.id] {
            
            self._todoItemList[todoItem.id] = todoItem
            
            saveData()
            
        }
        
    }
    
    func removeTodoItem(todoItem: TodoItem) {
        
        self._todoItemList.removeValueForKey(todoItem.id)
        
        saveData()
        
    }
    
    func getTodoItem(index: Int) -> TodoItem? {
        
        let list = self.todoItemList
                    .filter { _,_ in true }
                    .sort { $0.1.id < $1.1.id }
        
        if index >= 0 && index < list.count {
            
            return list[index].1
            
        }
        
        return nil
        
    }
    
}