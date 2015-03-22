//
//  TaskCellData.swift
//  7xTime
//
//  Created by 崔宇 on 15/2/25.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskCellData) class TaskCellData: NSManagedObject {

    @NSManaged var title: NSString
    @NSManaged var time: NSDate?
    @NSManaged var priority: NSNumber?
    @NSManaged var section: NSNumber
    @NSManaged var people: NSString?
    @NSManaged var row: NSNumber

}
