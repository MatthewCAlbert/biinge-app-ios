//
//  SessionHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation

// Will also function as timer facade
class SessionHelper {
    
    static let shared = SessionHelper()
    let sessionRepository = SessionRepository.shared
    
    private init() {
    }
    
    private func abort() {
        // Cancel AV
        AVHelper.shared.end()
        
        // Cancel Timer
        // TODO: Cancel timer here
        
        // Delete Session
        do {
            if let found = try sessionRepository.getOne(
                predicate: NSPredicate(format: "end == nil")
            ) {
                _ = try sessionRepository.deleteOne(found)
            }
        } catch {
            
        }
    }
    
    func start() throws {
        let found = try sessionRepository.getOne(
            predicate: NSPredicate(format: "end == nil")
        )
        
        // TODO: Start timer here
        
        if let _ = found {
            // TODO: Do something with previous session
        } else {
            // Start new session
            do {
                let newSession = Session()
                newSession.start = Date()
                newSession.end = nil
                newSession.targetEnd = nil // Date + Settings.shared.sessionLengthInMinute
                
                _ = try self.sessionRepository.create(newSession)
            } catch let error{
                self.abort()
                throw error
            }
        }
        
        AVHelper.shared.start()
    }
    
    func end() throws {
        guard let found = try sessionRepository.getOne(
            predicate: NSPredicate(format: "end == nil")
        ) else { return }
        
        // TODO: Stop timer here
        
        do {
            found.end = Date()
            _ = try self.sessionRepository.update(found)
        } catch let error{
            self.abort()
            throw error
        }
        AVHelper.shared.end()
    }
    
}
