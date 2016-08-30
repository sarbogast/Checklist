//
//  Checklist.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 26/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import Foundation

class Checklist: NSObject, NSCoding {
    let titleKey = "Title"
    let todosKey = "Todos"
    
    var title:String = ""
    var todos = [Todo]()
    
    init(withTitle:String) {
        self.title = withTitle
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init()
        title = aDecoder.decodeObjectForKey(titleKey) as! String
        todos = aDecoder.decodeObjectForKey(todosKey) as! [Todo]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeObject(todos, forKey: todosKey)
    }
    
    func numberOfUndoneTodos() -> Int {
        return todos.filter{ !$0.done }.count
    }
}