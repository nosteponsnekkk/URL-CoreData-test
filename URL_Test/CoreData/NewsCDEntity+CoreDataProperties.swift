//
//  NewsCDEntity+CoreDataProperties.swift
//  URL_Test
//
//  Created by Олег Наливайко on 24.09.2023.
//
//

import Foundation
import CoreData


extension NewsCDEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCDEntity> {
        return NSFetchRequest<NewsCDEntity>(entityName: "NewsCDEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var sourceURL: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var title: String?
    @NSManaged public var htmlData: String?

}

extension NewsCDEntity : Identifiable {

}
