//
//  CoreDataHelper.swift
//  7xTime
//
//  Created by 崔宇 on 15/2/25.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    var context  : NSManagedObjectContext = NSManagedObjectContext()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "cuiyu._xTime" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("TaskTableViewModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    init() {
        initContextEnvironment()
    }
    
    func initContextEnvironment() {
        // 从应用程序包中加载模型文件
        var model = NSManagedObjectModel.mergedModelFromBundles(nil)
        // 传入模型对象，初始化NSPersistentStoreCoordinator
        var psc: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("TaskTableViewModel.sqlite")
        var error : NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if psc!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            psc = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        self.context.persistentStoreCoordinator = psc
    }
    
    func getSectionsFromSql() -> NSArray {
        var request = NSFetchRequest(entityName: "Section")
        var sorter : NSSortDescriptor = NSSortDescriptor(key: "sectionNumber", ascending: true)
        request.sortDescriptors = [sorter]
        var fetchRequestResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: "sectionNumber", cacheName: nil)
        fetchRequestResults.performFetch(nil)
        var sectionArray : NSArray = fetchRequestResults.sections!
        return sectionArray
    }
    
    func getSectionNameFromSql(sectionNumber : NSString) -> String {
        println(sectionNumber , "____1111111111")
        var request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Section", inManagedObjectContext: self.context)
        // @表示占位符
        var predicate : NSPredicate =  NSPredicate(format: "sectionNumer == %@", sectionNumber)
        request.predicate = predicate
        var error : NSError? = nil
        var objs : NSArray = context.executeFetchRequest(request, error: &error)!
        if (error != nil) {
            println("查询错误")
        }
        var sectionName : String?
        for object : AnyObject in objs {
//            sectionName = (object.valueForKey("sectionTitle") as! String)
        }
        return sectionName!
    }
    
    func insertDataToSection(number : NSInteger, title : NSString) {
        println(applicationDocumentsDirectory)
        var sectionData = NSEntityDescription.insertNewObjectForEntityForName("Section", inManagedObjectContext: context) as! Section
        sectionData.sectionTitle = title as String
        sectionData.sectionNumber = number
        
        saveContext()
    }
    
    func getNumberOfRowsInSection(section : NSInteger) -> Int {
        var request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("TaskCellData", inManagedObjectContext: self.context)
        // @表示占位符
        var predicate : NSPredicate =  NSPredicate(format: "section == %d", section)
        request.predicate = predicate
        var error : NSError? = nil
        var objs : NSArray = context.executeFetchRequest(request, error: &error)!
        if (error != nil) {
            println("查询错误")
        }
        var count = objs.count
        return count
    }
    
    func getDataOfCell(cellIndexPath : NSIndexPath) -> AnyObject {
        println("getDataOfCell   ", cellIndexPath.row, "     ",  cellIndexPath.section)
        var request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("TaskCellData", inManagedObjectContext: self.context)
        var predicate : NSPredicate =  NSPredicate(format: "row == %d AND section == %d",cellIndexPath.row , cellIndexPath.section)
        request.predicate = predicate
        var error : NSError? = nil
        var objs : NSArray = context.executeFetchRequest(request, error: &error)!
        println(objs.count)
        if (error != nil) {
            println("查询错误")
        }
        var data: AnyObject = objs[0]
        return data
    }
    
    func insertDataToTaskCellData(people : NSString?, time : NSDate?, title : NSString!, priority : NSInteger?, section : NSNumber, row : NSNumber) {
        
        var indexPathForCell : NSIndexPath = NSIndexPath(forRow: row.integerValue, inSection: section.integerValue)
        
        updateRowInSection(indexPathForCell, insert: true)
        
        println(applicationDocumentsDirectory)
        var task = NSEntityDescription.insertNewObjectForEntityForName("TaskCellData", inManagedObjectContext: context) as! TaskCellData
        task.people = people
        task.time = time
        task.title = title
        task.priority = priority
        task.section = section
        task.row = row
        
        println("        row " ,task.row.integerValue)
        
        saveContext()
    }
    
    func insertDataToTaskCellData(taskCellData : TaskCellData) {
        insertDataToTaskCellData(taskCellData.people, time: taskCellData.time, title: taskCellData.title, priority: taskCellData.priority?.integerValue, section: taskCellData.section, row: taskCellData.row)
    }
    
    func deleteDataFromSQL(cellIndexPath : NSIndexPath) {
        var taskToDelete: AnyObject = getDataOfCell(cellIndexPath)
        self.context.deleteObject(taskToDelete as! NSManagedObject)
        saveContext()
        updateRowInSection(cellIndexPath, insert: false)
    }
    
    func modifyDataInSQL(key : NSString, queryString : NSString, newValue : NSObject) {
        var request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("TaskCellData", inManagedObjectContext: self.context)
        // @表示占位符
        var predicate : NSPredicate =  NSPredicate(format: queryString as String)
        println(queryString)
        request.predicate = predicate
        var error : NSError? = nil
        var objs : NSArray = context.executeFetchRequest(request, error: &error)!
        println("modifyDataInSQL", objs.count)
        var i = 0
        var task : TaskCellData!
        for object : AnyObject in objs {
            object.setValue(newValue, forKey: key as String)
            println(key , " = " , object.valueForKey(key as String), "    " ,newValue)
        }
        saveContext()
    }
    
    func updateRowInSection(cellIndexPath : NSIndexPath, insert: Bool) {
        var numberOfRowsInSection = getNumberOfRowsInSection(cellIndexPath.section)
        if insert {
            for (var row = numberOfRowsInSection - 1; row >= cellIndexPath.row; row--) {
                println("updateRowInSection: insert = true", "row   ", cellIndexPath.row, "     ",  cellIndexPath.section)
                var queryString : NSString = NSString(format:"row == %d AND section == %d", row, cellIndexPath.section)
                modifyDataInSQL("row", queryString: queryString, newValue: row + 1)
            }
        } else {
            println("updateRowInSection: insert = false", "row   ", cellIndexPath.row, "     ",  cellIndexPath.section)
            for (var row = cellIndexPath.row + 1; row <= numberOfRowsInSection; row++) {
                var queryString : NSString = NSString(format:"row == %d AND section == %d", row, cellIndexPath.section)
                modifyDataInSQL("row", queryString: queryString, newValue: row - 1)
            }
        }
    }
    
    func saveContext() {
        var error : NSError? = nil
        if context.hasChanges && !context.save(&error) {
            NSLog("Unresolved error %@, %@", error!, (error?.userInfo)!)
            abort()
        }
        
    }
    
}

