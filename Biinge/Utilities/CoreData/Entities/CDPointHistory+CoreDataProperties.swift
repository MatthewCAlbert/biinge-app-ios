//
//  CDPointHistory+CoreDataProperties.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//
//

import Foundation
import CoreData


extension CDPointHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPointHistory> {
        return NSFetchRequest<CDPointHistory>(entityName: "CDPointHistory")
    }

    @NSManaged public var action: String?
    @NSManaged public var amount: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?

}

extension CDPointHistory : Identifiable {

}
