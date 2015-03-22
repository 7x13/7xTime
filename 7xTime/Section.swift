//
//  Section.swift
//  7xTime
//
//  Created by 崔宇 on 15/2/25.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import Foundation
import CoreData

@objc(Section) class Section: NSManagedObject {

    @NSManaged var sectionTitle: String
    @NSManaged var sectionNumber: NSNumber

}
