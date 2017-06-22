//
//  MZRealmManager.swift
//  Pods
//
//  Created by muzcity on 2017. 6. 22..
//
//

import Foundation
import RealmSwift


final public class MZRealmManager : NSObject {
    
    public typealias MZ_INT_HANDLER = ((Int)->())?
    
    private var  workerThread : dispatch_queue_t! = dispatch_queue_create("realm db worker thread", DISPATCH_QUEUE_SERIAL)
    private var db : Realm!
    private var token : NotificationToken!
    
    public static var migrationList : [MZRealmMigratable.Type] = []
    public static var SCHEMA_VERSION : UInt64 = 0
    
    public override init() {
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion : MZRealmManager.SCHEMA_VERSION, migrationBlock : { migration, oldSchemaVersion in
            
            if (oldSchemaVersion < MZRealmManager.SCHEMA_VERSION) {
                
                MZRealmManager.migrationList.forEach({ (dbModel) in
                    
                    migration.enumerate(dbModel.objectName(), { (oldObject, newObject) in
                        
                        dbModel.migration(oldSchemaVersion, oldObject: oldObject, newObject: newObject)
                    })
                    
                })
                
            }
            
        })
        
    }
    
    private static func fileCreateFailed() {
        fatalError("db file create failed")
    }
    
    private static func makeRealmDB() -> Realm! {
        return try? Realm()
    }
    
    private func createDb() {
        if nil == db {
            db = MZRealmManager.makeRealmDB()
        }
        
        if nil == db {
            MZRealmManager.fileCreateFailed()
        }
        
    }
    
    /**
     * 해당 타입에 해당하는 카운트를 리턴한다.
     */
    public func count<T : Object>(type: T.Type) -> Int {
        
        
        var count : Int = 0
        syncWorkerThread {
            
            if let db = MZRealmManager.makeRealmDB() {
                count = db.objects(type).count
            }
            
        }
        
        return count
    }
    
    /**
     * 비동기로 카운트를 얻는다.
     */
    public func asyncCount<T : Object>(type:T.Type, handler : MZ_INT_HANDLER) {
        
        asyncWorkerThread { [weak self] in
            
            guard let `self` = self else {
                handler?(0)
                return
            }
            
            let count = self.count(type)
            
            self.asyncMainThread({
                handler?(count)
            })
            
        }
        
    }
    
    
    
    /**
     * 조건절 추가. 해당 객체의 모든 데이터를 얻으려면 "" 입력.
     */
    public func filter<T:Object>(type:T.Type, query : String = "" ) -> Results<T>? {
        
        var resultAny : Any?
        syncWorkerThread {
            
            if let db = MZRealmManager.makeRealmDB() {
                
                if query.isEmpty {
                    let results = db.objects(type)
                    resultAny = results
                }
                else {
                    let results = db.objects(type).filter(query)
                    resultAny = results
                }
                
            }
            
        }
        
        return resultAny as? Results<T>
    }
    
    /**
     * 비동기 조건절 추가. 해당 객체의 모든 데이터를 얻으려면 "" 입력
     */
    public func asyncFilter <T:Object>(type:T.Type, query : String = "", resultHandler:((Results<T>)->())?) {
        
        asyncWorkerThread {
            
            if let db = MZRealmManager.makeRealmDB() {
                
                if query.isEmpty {
                    let results = db.objects(type)
                    
                    resultHandler?(results)
                }
                else {
                    let results = db.objects(type).filter(query)
                    
                    resultHandler?(results)
                }
            }
            else {
                MZRealmManager.fileCreateFailed()
            }
        }
        
    }
    
    /**
     * 디비에 객체를 때려박는다.
     */
    public func add(object obj:Object) {
        
        createDb()
        
        try! db.write({
            db.add(obj)
        })
        
    }
    
    /**
     * 비동기로 디비에 객체를 쑤셔넣는다.
     */
    public func asyncAdd(object obj:Object) {
        
        asyncWorkerThread {
            
            if let db = MZRealmManager.makeRealmDB() {
                
                try! db.write({
                    db.add(obj)
                })
            }
            else {
                MZRealmManager.fileCreateFailed()
            }
            
        }
    }
    
    /**
     * 해당 객체 제거
     */
    public func remove(object obj:Object) {
        
        createDb()
        
        try! db.write({
            db.delete(obj)
        })
    }
    
    /**
     * 비동기로 해당 객체 제거
     */
    public func asyncRemove(object obj:Object) {
        
        asyncWorkerThread {
            
            if let db = MZRealmManager.makeRealmDB() {
                
                try! db.write({
                    db.delete(obj)
                })
            }
            else {
                MZRealmManager.fileCreateFailed()
            }
            
        }
        
    }
    
    /**
     * 노티 등록
     */
    public func addNotifications<T>(target: Results<T>, completeHandler:(( obj : Results<T>, deletions : [Int], insertions : [Int], modifications : [Int]  )->())?) {
        
        token = target.addNotificationBlock { (changes) in
            
            switch changes {
            case .Initial( _) :
                //                print("init")
                break
            case .Update(let f, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                completeHandler?(obj: f, deletions: deletions, insertions: insertions, modifications: modifications)
            default :
                break
            }
            
        }
        
    }
    
    /**
     * 노티해제
     */
    public func removeNotifications() {
        if nil != token {
            token.stop()
        }
    }
    
    
    
    //메인쓰레드로 블럭내를 실행시킨다.
    private func asyncMainThread(block: ()->()) {
        dispatch_async(dispatch_get_main_queue(), {
            autoreleasepool(block)
        })
    }
    
    private func asyncWorkerThread(block: ()->()) {
        
        dispatch_async(workerThread, {
            autoreleasepool(block)
        })
    }
    
    private func syncWorkerThread(block: ()->()) {
        dispatch_sync(workerThread, {
            autoreleasepool(block)
        })
    }
    
    
    deinit {
        if nil != token {
            token.stop()
            token = nil
        }
    }
    
    
    
}
