//
//  UserCDEntity+CoreDataProperties.swift
//  URL_Test
//
//  Created by Олег Наливайко on 30.09.2023.
//
//

import Foundation
import CoreData


extension UserCDEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCDEntity> {
        return NSFetchRequest<UserCDEntity>(entityName: "UserCDEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var picture: Data?

}

extension UserCDEntity : Identifiable {

}
