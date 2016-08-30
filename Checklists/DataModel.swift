//
//  DataModel.swift
//  Checklists
//
//  Created by Sebastien Arbogast on 30/08/2016.
//  Copyright © 2016 BusinessTraining. All rights reserved.
//

import Foundation

class DataModel {
    static let sharedModel = DataModel()
    let checklistsKey = "checklists"
    
    var lists = [Checklist]()
    
    private init() {
        print("Data file path: \(dataFilePath())")
        loadChecklists()
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
        archiver.encodeObject(lists, forKey: checklistsKey)
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
                self.lists = unarchiver.decodeObjectForKey(checklistsKey) as! [Checklist]
            }
        }
    }
}