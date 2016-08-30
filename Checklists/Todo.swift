//
//  Todo.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 30/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import Foundation

class Todo: NSObject, NSCoding {
    let titleKey = "Title"
    let doneKey = "Done"
    
    var title = ""
    var done = false
    
    init(withTitle:String) {
        super.init()
        self.title = withTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        title = aDecoder.decodeObjectForKey(titleKey) as! String
        done = aDecoder.decodeBoolForKey(doneKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeBool(done, forKey: doneKey)
    }
}