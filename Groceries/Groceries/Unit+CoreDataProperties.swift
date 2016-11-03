//
//  Unit+CoreDataProperties.swift
//  Groceries
//
//  Created by MacMini on 11/3/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit");
    }

    @NSManaged public var name: String?

}
