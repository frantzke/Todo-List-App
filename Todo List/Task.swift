//
//  Task.swift
//  Todo List
//
//  Created by Lukas on 2019-09-11.
//  Copyright © 2019 Lukas. All rights reserved.
//

import Foundation
import os.log


class Task: NSObject, NSCoding {
    
    var name:String
    var isCompleted:Bool
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    init(name: String, isCompleted: Bool) {
        self.name = name
        self.isCompleted = isCompleted
    }
    
//    struct PropertyKey {
//        static let taskName = "name"
//        static let isCompleted = "isCompleted"
//    }
    
    enum Keys: String {
        case name = "name"
        case isCompleted = "isCompleted"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name.rawValue)
        aCoder.encode(isCompleted, forKey: Keys.isCompleted.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String ?? ""
        let isCompleted = aDecoder.decodeBool(forKey: Keys.isCompleted.rawValue)
//        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
//            os_log("Unable to decode task object")
//            return nil
//        }
//        
//        guard let isCompleted = aDecoder.decodeObject(forKey: "isCompleted") as? Bool else {
//            os_log("Unable to decode task object")
//            return nil
//        }
        
        self.init(name: name, isCompleted: isCompleted)
        
    }
    
    
}
