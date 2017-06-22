//
//  MZRealmBaseObject.swift
//  Pods
//
//  Created by muzcity on 2017. 6. 22..
//
//

import Foundation
import RealmSwift

public class MZRealmBaseObject : Object , MZRealmMigratable {
    public static func migration(oldVersion : UInt64, oldObject:MigrationObject?, newObject:MigrationObject?)  {}
    public static func objectName() -> String                                                               { return MZRealmBaseObject.className() }
}
