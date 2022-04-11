//
//  PointHistoryRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation
import CoreData

class PointHistoryRepository {
    
    static let shared = PointHistoryRepository()
    private let repository: CoreDataRepository<CDPointHistory>
    
    private init() {
        self.repository = CoreDataRepository<CDPointHistory>(entityName: "CDPointHistory")
    }
    
    private func toDomain(_ cd: CDPointHistory) -> PointHistory {
        return PointHistory(
            id: cd.id?.uuidString,
            action: cd.action,
            amount: cd.amount,
            createdAt: cd.createdAt
        )
    }
    
    func getAll(predicate: NSPredicate?) throws -> [PointHistory] {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let pointHistories):
            // Transform the NSManagedObject objects to domain objects
            let results = pointHistories.map { pointHistory -> PointHistory in
                return self.toDomain(pointHistory)
            }
            
            return results
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }

    func getOne(predicate: NSPredicate?) throws -> PointHistory? {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let pointHistories):
            // Transform the NSManagedObject objects to domain objects
            if pointHistories.isEmpty {
                return nil
            }
            return self.toDomain(pointHistories.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func getOne(id: String) throws -> PointHistory? {
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let pointHistories):
            // Transform the NSManagedObject objects to domain objects
            if pointHistories.isEmpty {
                return nil
            }
            return self.toDomain(pointHistories.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func update(_ entity: PointHistory) throws -> PointHistory {
        guard let id = entity.id else { throw CoreDataError.coreDataEntryNotFound }
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let pointHistories):
            if pointHistories.isEmpty {
                throw CoreDataError.coreDataEntryNotFound
            }
            
            let pointHistory = pointHistories.first
            
            pointHistory?.action = entity.action?.rawValue
            pointHistory?.amount = entity.amount
            pointHistory?.createdAt = entity.createdAt
            
            _ = self.repository.save()
            return self.toDomain(pointHistory!)
        case .failure(let error):
            throw error
        }
    }
    
    func create(_ entity: PointHistory) throws -> PointHistory {
        let result = repository.create()
        switch result {
        case .success(let pointHistory):
            if let id = entity.id {
                pointHistory.id = UUID(uuidString: id)
            } else {
                pointHistory.id = UUID()
            }
            pointHistory.action = entity.action?.rawValue
            pointHistory.amount = entity.amount
            pointHistory.createdAt = entity.createdAt
            
            if !self.repository.save() {
                throw CoreDataError.coreDataFailedToSave
            }
            
            return self.toDomain(pointHistory)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
}
