//
//  MZRealmMigratable.swift
//  Pods
//
//  Created by muzcity on 2017. 6. 22..
//
//

import Foundation
import RealmSwift

public protocol MZRealmMigratable {
    static func migration(oldVersion : UInt64, oldObject:MigrationObject?, newObject:MigrationObject?)
    static func objectName() -> String
}
