//
//  SGScore+CoreDataProperties.swift
//  SnakeGame
//
//  Created by lichunwang on 16/4/8.
//  Copyright © 2016年 thunder. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SGScore {

    @NSManaged var addtime: NSDate?
    @NSManaged var score: NSNumber?
    @NSManaged var scoreid: String?

}
