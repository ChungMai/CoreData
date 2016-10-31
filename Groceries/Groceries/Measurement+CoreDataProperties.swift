//
//  Measurement+CoreDataProperties.swift
//  Groceries
//
//  Created by Home on 10/24/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData


extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement");
    }

    @NSManaged public var name: String?

}
