//
//  Amount+CoreDataProperties.swift
//  Groceries
//
//  Created by Home on 10/24/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData


extension Amount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Amount> {
        return NSFetchRequest<Amount>(entityName: "Amount");
    }

    @NSManaged public var amountName: String?

}
