
//
//  CDHelper.swift
//  Groceries
//
//  Created by Home on 10/22/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData

private let _shareCDHelper = CDHelper()
class CDHelper : NSObject{
    class var shared:CDHelper{
        return _shareCDHelper
    }
    
    //MARK: - PATH
    lazy var storesDirectory: NSURL? = {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in:.userDomainMask)
        return urls[urls.count-1] as NSURL?
    }()
    
    lazy var localStoreURL: NSURL? = {
        if let url = self.storesDirectory?.appendingPathComponent("LocalStore.sqlite") {
            print("localStoreURL = \(url)")
            return url as NSURL?
        }
        return nil
    }()
    
    lazy var  modelURL : NSURL = {
        let bundle = Bundle.main
        if let url = bundle.url(forResource: "Model", withExtension: "momd"){
            return url as NSURL
        }
        
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    // MARK: - CONTEXT
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.coordinator
        return moc
    }()
    
    // MARK: - MODEL
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf:self.modelURL as URL)!
    }()
    
    // MARK: - COORDINATOR
    lazy var coordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
    
    // MARK: Store
    
    lazy var localStore : NSPersistentStore? = {
        let options : [String : Any] = [NSSQLitePragmasOption:["journal_mode":"DELETE"], NSMigratePersistentStoresAutomaticallyOption:false, NSInferMappingModelAutomaticallyOption:false]
        var _localStore:NSPersistentStore?
        do{
            _localStore = try self.coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at:self.localStoreURL as URL?, options: options)
            return _localStore
        } catch {
            return nil
        }
    }()
    
    required override init() {
        super.init()
        self.setupCoreData()
    }
    
    func setupCoreData(){
        _ = self.localStore
    }
    
    class func saveSharedContext(){
        save(moc: shared.context)
    }
    
    class func save(moc:NSManagedObjectContext){
        moc.performAndWait {
            if moc.hasChanges{
                do{
                    try moc.save()
                }
                catch{
                   print("ERROR saving context \(moc.description) - \(error)")
                }
            }
            else{
                print("No data changed")
            }
            
            if let parentContext = moc.parent{
                save(moc: parentContext)
            }
        }
    }
}
