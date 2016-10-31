//
//  CDMigration.swift
//  Groceries
//
//  Created by Home on 10/31/16.
//  Copyright © 2016 Tim Roadley. All rights reserved.
//

import Foundation

private let _sharedCDMigration = CDMigration()
class CDMigration:NSObject{
    class var shared : CDMigration{
        return _sharedCDMigration
    }
}
