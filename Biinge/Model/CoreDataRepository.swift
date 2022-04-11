//
//  BaseRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation
import UIKit
import CoreData

protocol AbstractCoreDataRepository {
    associatedtype Entity: NSManagedObject
    
    var context: NSManagedObjectContext { get }
    
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
    func create() -> Result<Entity, Error>
    func deleteOne(entity: Entity) -> Result<Bool, Error>
    func deleteMany(predicate: NSPredicate?) -> Result<Bool, Error>
}

enum CoreDataError: Error {
    case invalidManagedObjectType
    case coreDataEntryNotFound
    case coreDataFailedToSave
}

class CoreDataRepository<T: NSManagedObject>: AbstractCoreDataRepository {
    typealias Entity = T
    
    let entityName: String
    let context = CoreDataStack().context
    
    init(entityName: String) {
        self.entityName = entityName
    }
    
    /// Gets an array of NSManagedObject entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    /// - Returns: A result consisting of either an array of NSManagedObject entities or an Error.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = NSFetchRequest<Entity>(entityName: self.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            // Perform the fetch request
            if let fetchResults = try self.context.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }

    /// Creates a NSManagedObject entity.
    /// - Returns: A result consisting of either a NSManagedObject entity or an Error.
    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: self.context) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }
    
    /// Save a NSManagedObject entity.
    /// - Returns: A result consisting of either a boolean or an Error.
    func save() -> Bool {
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }

    /// Deletes a NSManagedObject entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    /// - Returns: A result consisting of either a Bool set to true or an Error.
    func deleteOne(entity: Entity) -> Result<Bool, Error> {
        self.context.delete(entity)
        return .success(true)
    }

    /// Deletes many NSManagedObject entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    /// - Returns: A result consisting of either a Bool set to true or an Error.
    func deleteMany(predicate: NSPredicate?) -> Result<Bool, Error> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.entityName)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            return .success(true)
        } catch let error as NSError {
            return .failure(error)
        }
    }
}
