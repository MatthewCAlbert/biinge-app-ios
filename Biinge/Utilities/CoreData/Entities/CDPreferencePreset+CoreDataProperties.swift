//
//  CDPreferencePreset+CoreDataProperties.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//
//

import Foundation
import CoreData


extension CDPreferencePreset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPreferencePreset> {
        return NSFetchRequest<CDPreferencePreset>(entityName: "CDPreferencePreset")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sessionLength: Int16

}

extension CDPreferencePreset : Identifiable {

}
