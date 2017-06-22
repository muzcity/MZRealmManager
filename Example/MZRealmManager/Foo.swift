//
//  Foo.swift
//  MZRealmManager
//
//  Created by muzcity on 2017. 6. 22..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import Foundation
import RealmSwift
import MZRealmManager


public class Foo : MZRealmBaseObject {
    dynamic var name : String = ""
    dynamic var time : Int = 0
    
    //schema version 2
    dynamic var cnt : Int = 100
    //schema version 3
    dynamic var firstName : String = ""
    
    
    func migration(oldVersion : UInt64, oldObject:MigrationObject?, newObject:MigrationObject?) {
        
        switch oldVersion {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            newObject?["cnt"] = 1001
            newObject?["firstName"] = "abc"
            break
        case 4:
            newObject?["cnt"] = 2001
            newObject?["firstName"] = "def"
            break
        default:
            newObject?["cnt"] = -1
            newObject?["firstName"] = "xyz"
            break
        }
    }
    
    func objectName() -> String {
        return Foo.className()
    }
    
}
