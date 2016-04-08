//
//  ScoreManager.swift
//  SnakeGame
//
//  Created by lichunwang on 16/4/6.
//  Copyright © 2016年 thunder. All rights reserved.
//

import UIKit
import CoreData

class ScoreManager: NSObject {
    
    class func insertScore(score: Int64) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
        let context = appDelegate.managedObjectContext
        
        let scoreItem: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("SGScore", inManagedObjectContext: context)
        scoreItem.setValue(NSUUID().UUIDString, forKey: "scoreid")
        let now = NSDate()
        scoreItem.setValue(NSNumber.init(longLong: score), forKey: "score")
        scoreItem.setValue(now, forKey: "addtime")
        
        do {
            try context.save()
        } catch {
            print("context save error")
        }
    }
    
    class func queryAllScores() -> NSArray {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
        let context = appDelegate.managedObjectContext
        
        let score: NSEntityDescription = NSEntityDescription.entityForName("SGScore", inManagedObjectContext: context)!
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = score
        
        do {
            let results = try context.executeFetchRequest(request)
            for result in results {
                print("scoreid = \(result.valueForKey("scoreid")) score = \(result.valueForKey("score")) addtime = \(result.valueForKey("addtime"))")
            }
            return results
        } catch {
            print("context query error")
            return []
        }
    }
    
    class func deleteScoreWithScoreId(scoreId: String) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
        let context = appDelegate.managedObjectContext
        
        let score: NSEntityDescription = NSEntityDescription.entityForName("SGScore", inManagedObjectContext: context)!
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = score
        
        let predicate = NSPredicate(format: "scoreid=%@", scoreId)
        request.predicate = predicate
        do {
            let obj = try context.executeFetchRequest(request).last
            let score: NSManagedObject = obj as! NSManagedObject
            context.deleteObject(score)
            try context.save()
        } catch {
            print("context delete error")
        }
    }
    
    class func updateScoreWithScoreId(scoreId: String) {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as? AppDelegate)!
        let context = appDelegate.managedObjectContext
        
        let score: NSEntityDescription = NSEntityDescription.entityForName("SGScore", inManagedObjectContext: context)!
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = score
        
        let predicate = NSPredicate(format: "scoreid=%@", scoreId)
        request.predicate = predicate
        do {
            let obj = try context.executeFetchRequest(request).last
            let score: NSManagedObject = obj as! NSManagedObject
            score.setValue("1000", forKey: "score")
            try context.save()
        } catch {
            print("context update success")
        }
    }
}
