//
//  PreferencePresetRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation
import CoreData

class PreferencePresetRepository {
    
    static let shared = PreferencePresetRepository()
    private let repository: CoreDataRepository<CDPreferencePreset>
    
    private init() {
        self.repository = CoreDataRepository<CDPreferencePreset>(entityName: "CDPreferencePreset")
    }
    
    private func toDomain(_ cd: CDPreferencePreset) -> PreferencePreset {
        return PreferencePreset(
            id: cd.id?.uuidString,
            name: cd.name,
            sessionLength: cd.sessionLength
        )
    }
    
    func getAll(predicate: NSPredicate?) throws -> [PreferencePreset] {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let preferencePresets):
            // Transform the NSManagedObject objects to domain objects
            let results = preferencePresets.map { preferencePreset -> PreferencePreset in
                return self.toDomain(preferencePreset)
            }
            
            return results
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }

    func getOne(predicate: NSPredicate?) throws -> PreferencePreset? {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let preferencePresets):
            // Transform the NSManagedObject objects to domain objects
            if preferencePresets.isEmpty {
                return nil
            }
            return self.toDomain(preferencePresets.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func getOne(id: String) throws -> PreferencePreset? {
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let preferencePresets):
            // Transform the NSManagedObject objects to domain objects
            if preferencePresets.isEmpty {
                return nil
            }
            return self.toDomain(preferencePresets.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func update(_ entity: PreferencePreset) throws -> PreferencePreset {
        guard let id = entity.id else { throw CoreDataError.coreDataEntryNotFound }
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let preferencePresets):
            if preferencePresets.isEmpty {
                throw CoreDataError.coreDataEntryNotFound
            }
            
            let preferencePreset = preferencePresets.first
            
            preferencePreset?.name = entity.name
            preferencePreset?.sessionLength = entity.sessionLength
            
            _ = self.repository.save()
            return self.toDomain(preferencePreset!)
        case .failure(let error):
            throw error
        }
    }
    
    func create(_ entity: PreferencePreset) throws -> PreferencePreset {
        let result = repository.create()
        switch result {
        case .success(let preferencePreset):
            if let id = entity.id {
                preferencePreset.id = UUID(uuidString: id)
            } else {
                preferencePreset.id = UUID()
            }
            preferencePreset.name = entity.name
            preferencePreset.sessionLength = entity.sessionLength
            
            if !self.repository.save() {
                throw CoreDataError.coreDataFailedToSave
            }
            
            return self.toDomain(preferencePreset)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }

    func deleteOne(_ entity: PreferencePreset) throws -> Bool {
        guard let id = entity.id else { throw CoreDataError.coreDataEntryNotFound }
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let preferencePresets):
            if preferencePresets.isEmpty {
                throw CoreDataError.coreDataEntryNotFound
            }
            
            let preferencePreset = preferencePresets.first
            
            let deleteResult = self.repository.deleteOne(entity: preferencePreset!)
            switch deleteResult {
                case .success(_):
                    return true
                case .failure(_):
                    return false
            }
        case .failure(let error):
            throw error
        }
    }

    
}

