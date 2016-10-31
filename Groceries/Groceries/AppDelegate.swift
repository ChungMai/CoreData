//
//  AppDelegate.swift
//  Groceries
//
//  Created by Tim Roadley on 29/09/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //demoInsert()
        //demoSelect()
        //ddemoDelete()
        //demoSelectTemplate()
        //demoInsertMeasurement()
        demoFetchAmount()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CDHelper.saveSharedContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CDHelper.saveSharedContext()
    }
    func demoInsert(){
        let itemNames = ["Apples", "Milk", "Bread", "Cheese", "Sausages","Butter", "Orange Juice", "Cereal", "Coffee", "Eggs", "Tomatoes", "Fish"]
        
        for itemName in itemNames{
            if let item : Item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: CDHelper.shared.context) as? Item{
                item.name = itemName
            }
        }
        CDHelper.saveSharedContext()
    }
    
    func demoSelect(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let sort  = NSSortDescriptor(key:"name", ascending:true)
        request.sortDescriptors = [sort]
        let filter = NSPredicate(format:"name != %@", "Coffee")
        request.predicate = filter
        
        do{
            if let items = try CDHelper.shared.context.fetch(request) as? [Item]{
                for name in items{
                    print("Fetched Managed Object = '\(name.name)'")
                }
            }
        }
        catch{
            print("Error executing a fetch request: \(error)")
        }
    }
    
    func demoSelectTemplate(){
        let model = CDHelper.shared.model
        if let rquest = model.fetchRequestTemplate(forName:"FilterForItem")?.copy() as? NSFetchRequest<Item>{
            let sort = NSSortDescriptor(key: "name", ascending: true)
            rquest.sortDescriptors = [sort]
            do{
                if let items = try CDHelper.shared.context.fetch(rquest) as? [Item]{
                    for name in items{
                        print("Fetched Managed Object = '\(name.name)'")
                    }
                }
            }
            catch{
                print("Error executing a fetch request: \(error)")
            }
        }
    }
    
    func demoDelete(){
        let reqest : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            if let items = try CDHelper.shared.context.fetch(reqest) as? [Item]{
                for item in items{
                    if let name = item.name{
                        print("Deleted item name: \(name)")
                        CDHelper.shared.context.delete(item)
                    }
                }
            }
        }
        catch {
            print("ERROR executing a fetch request: \(error)")
        }
    }
    
    func demoInsertMeasurement(){
        for i in 0...50000{
            if let newMeasurement = NSEntityDescription.insertNewObject(forEntityName: "Measurement", into: CDHelper.shared.context) as? Measurement{
                newMeasurement.name = "Lots data to test \(i)"
                print("Insert measurement \(newMeasurement.name)")
            }
        }
        CDHelper.saveSharedContext()
    }
    
    func demoFetchMeasurement(){
        let request : NSFetchRequest<Measurement> = Measurement.fetchRequest()
        request.fetchLimit = 50
        do{
            if let measurements = try CDHelper.shared.context.fetch(request) as? [Measurement]{
                for measurement in measurements{
                    print("Measurement: \(measurement.name)")
                }
            }
        }
        catch {
            print("ERROR executing a fetch request: \(error)")
        }
    }
    
    func demoFetchAmount(){
        let request : NSFetchRequest<Amount> = Amount.fetchRequest()
        request.fetchLimit = 50
        do{
            if let measurements = try CDHelper.shared.context.fetch(request) as? [Amount]{
                for measurement in measurements{
                    print("Amount: \(measurement.amountName)")
                }
            }
        }
        catch {
            print("ERROR executing a fetch request: \(error)")
        }
    }

}

