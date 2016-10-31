//
//  Item+CoreDataProperties.swift
//  Groceries
//
//  Created by Home on 10/23/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Float
    @NSManaged public var photoData: NSData?
    @NSManaged public var listed: Bool
    @NSManaged public var collected: Bool

}
