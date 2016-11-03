//
//  CDMigration.swift
//  Groceries
//
//  Created by Home on 10/31/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let _sharedCDMigration = CDMigration()
class CDMigration:NSObject{
    class var shared : CDMigration{
        return _sharedCDMigration
    }
    
    func storeExistsAtPath(storeURL:NSURL)-> Bool{
        if let _storePath = storeURL.path {
            if FileManager.default.fileExists(atPath: _storePath){
                return true
            }
        }
        else{
            print("\(#function) failed to get store path")
        }
        
        return false
    }
    
    func store(storeURL:NSURL, isCompatibleWithModel model:NSManagedObjectModel) -> Bool{
        if self.storeExistsAtPath(storeURL: storeURL) == false{
            return true
        }
        
        do{
            var _metadata:[String:Any]?
            _metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL as URL)
            if let metadata = _metadata{
                if model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata){
                    print("The store is compatible with the current version of the model")
                    return true
                }
                else{
                    print("\(#function) FAILED to get metadata")
                }
                
            }
        }
        catch{
            print("ERROR getting metadata from \(storeURL) \(error)")
        }
        
        print("The store is NOT compatible with the current version of the model")
        return false
    }
    
    func replaceStore(oldStore:NSURL, newStore:NSURL) throws{
        let manager = FileManager.default
        do{
            try manager.removeItem(at: oldStore as URL)
            try manager.moveItem(at: newStore as URL, to: oldStore as URL)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is NSMigrationManager, let manager = object as? NSMigrationManager{
            if let notification = keyPath{
                NotificationCenter.default.post(name: NSNotification.Name(notification), object: NSNumber(value: manager.migrationProgress))
            }
            else {
                print("observeValueForKeyPath did not receive a NSMigrationManager class")
            }
        }
    }
    
    // MARK: - MIGRATION
    func migrateStore(store:NSURL, sourceModel:NSManagedObjectModel,destinationModel:NSManagedObjectModel) {
        
        if let tempdir = store.deletingLastPathComponent {
            
            let tempStore = tempdir.appendingPathComponent("Temp.sqlite")
            let mappingModel = NSMappingModel(from: nil, forSourceModel: sourceModel, destinationModel: destinationModel)
            let migrationManager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
            migrationManager.addObserver(self, forKeyPath: "migrationProgress", options: NSKeyValueObservingOptions.new, context: nil)
            
            do {
                
                try migrationManager.migrateStore(from: store as URL, sourceType: NSSQLiteStoreType, options: nil,with: mappingModel,
                                       toDestinationURL: tempStore, destinationType: NSSQLiteStoreType,destinationOptions: nil)
                
                try replaceStore(oldStore: store, newStore: tempStore as NSURL)
                print("SUCCESSFULLY MIGRATED \(store) to the Current Model")
            }
            catch {
                
                print("FAILED MIGRATION: \(error)")
            }
            
            migrationManager.removeObserver(self, forKeyPath:"migrationProgress")
        }
        else {
            print("\(#function) FAILED to prepare temporary directory")
        }
    }
    
    func migrateStoreWithProgressUI(store:NSURL,sourceModel:NSManagedObjectModel, destinationModel:NSManagedObjectModel) {
        // Show migration progress view preventing the user from using the app
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialVC = UIApplication.shared.keyWindow?.rootViewController as?
            UINavigationController {
            if let migrationVC =
                storyboard.instantiateViewController(withIdentifier: "migration") as? MigrationVC {
                initialVC.present(migrationVC, animated: false,
                                                completion: {
                                                    DispatchQueue.global(qos: .background).async {
                                                        print("BACKGROUND Migration started…")
                                                        self.migrateStore(store: store, sourceModel: sourceModel, destinationModel: destinationModel)
                                                        DispatchQueue.main.async {
                                                            // trigger the stack setup again, this time with the upgraded store
                                                            let _ = CDHelper.shared.localStore
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000), execute: {
                                                                migrationVC.dismiss(animated: false,completion: nil)
                                                            });
                                                            
                                                        }
                                                        
                                                    }

                })
            } else {
                print("FAILED to find a view controller with a story board id of 'migration'")
            }
        } else {
            print("FAILED to find the root view controller, which is supposed to be a navigation controller")
        }
    }
    
    func migrateStoreIfNecessary (storeURL:NSURL,destinationModel:NSManagedObjectModel) {
        if storeExistsAtPath(storeURL: storeURL) == false {
            return
        }
        if store(storeURL: storeURL, isCompatibleWithModel: destinationModel) {
            return
        }
        do {
            var _metadata:[String : Any]?
            _metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType:NSSQLiteStoreType, at:storeURL as URL)
            if let metadata = _metadata, let sourceModel = NSManagedObjectModel.mergedModel(from: [Bundle.main], forStoreMetadata: metadata){
                
                self.migrateStoreWithProgressUI(store: storeURL, sourceModel:sourceModel, destinationModel: destinationModel)
            }
        } catch {
            print("\(#function) FAILED to get metadata \(error)")
        }
    }
    
}
