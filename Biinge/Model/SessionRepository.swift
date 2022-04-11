//
//  SessionRepository.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 10/04/22.
//

import Foundation
import CoreData

class SessionRepository {
    
    static let shared = SessionRepository()
    private let repository: CoreDataRepository<CDSession>
    
    private init() {
        self.repository = CoreDataRepository<CDSession>(entityName: "CDSession")
    }
    
    private func toDomain(_ cd: CDSession) -> Session {
        return Session(
            id: cd.id?.uuidString,
            start: cd.start,
            end: cd.end,
            targetEnd: cd.targetEnd,
            appSession: cd.appSession
        )
    }
    
    func getAll(predicate: NSPredicate?) throws -> [Session] {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let sessions):
            // Transform the NSManagedObject objects to domain objects
            let results = sessions.map { session -> Session in
                return self.toDomain(session)
            }
            
            return results
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }

    func getOne(predicate: NSPredicate?) throws -> Session? {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let sessions):
            // Transform the NSManagedObject objects to domain objects
            if sessions.isEmpty {
                return nil
            }
            return self.toDomain(sessions.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func getOne(id: String) throws -> Session? {
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let sessions):
            // Transform the NSManagedObject objects to domain objects
            if sessions.isEmpty {
                return nil
            }
            return self.toDomain(sessions.first!)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }
    
    func update(_ entity: Session) throws -> Session {
        guard let id = entity.id else { throw CoreDataError.coreDataEntryNotFound }
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let sessions):
            if sessions.isEmpty {
                throw CoreDataError.coreDataEntryNotFound
            }
            
            let session = sessions.first
            
            session?.start = entity.start
            session?.end = entity.end
            session?.targetEnd = entity.targetEnd
            
            _ = self.repository.save()
            return self.toDomain(session!)
        case .failure(let error):
            throw error
        }
    }
    
    func create(_ entity: Session) throws -> Session {
        let result = repository.create()
        switch result {
        case .success(let session):
            if let id = entity.id {
                session.id = UUID(uuidString: id)
            } else {
                session.id = UUID()
            }
            session.start = entity.start
            session.end = entity.end
            session.appSession = entity.appSession ?? Settings.shared.currentSessionStart
            
            if !self.repository.save() {
                throw CoreDataError.coreDataFailedToSave
            }
            
            return self.toDomain(session)
        case .failure(let error):
            // Return the Core Data error.
            throw error
        }
    }

    func deleteOne(_ entity: Session) throws -> Bool {
        guard let id = entity.id else { throw CoreDataError.coreDataEntryNotFound }
        let result = self.repository.get(predicate: NSPredicate(format: "id == %@", id), sortDescriptors: nil)
        switch result {
        case .success(let sessions):
            if sessions.isEmpty {
                throw CoreDataError.coreDataEntryNotFound
            }
            
            let session = sessions.first
            
            let deleteResult = self.repository.deleteOne(entity: session!)
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

    func deleteMany(predicate: NSPredicate?) throws -> Bool {
        let deleteResult = self.repository.deleteMany(predicate: predicate)
        switch deleteResult {
            case .success(_):
                return true
            case .failure(_):
                return false
        }
    }
    
}
