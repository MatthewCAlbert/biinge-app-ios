//
//  CDSession+CoreDataProperties.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//
//

import Foundation
import CoreData


extension CDSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSession> {
        return NSFetchRequest<CDSession>(entityName: "CDSession")
    }

    @NSManaged public var end: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var start: Date?
    @NSManaged public var targetEnd: Date?

}

extension CDSession : Identifiable {

}
