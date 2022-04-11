//
//  SessionHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation

struct PointReward {
    static let success = 10
    static let failed = 0
}

// Will also function as timer facade
class SessionHelper {
    
    static let shared = SessionHelper()
    let sessionRepository = SessionRepository.shared
    let pointHistoryRepository = PointHistoryRepository.shared
    
    let currentSessionPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "end == nil"),
        NSPredicate(format: "appSession == %@", Settings.shared.currentSessionStart as NSDate)
    ])
    
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
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "end == nil"),
            NSPredicate(format: "appSession != %@", Settings.shared.currentSessionStart as NSDate)
        ])
        let founds = try sessionRepository.getAll(predicate: predicate)
        
        // TODO: Start timer here
        
        if !founds.isEmpty {
            _ = try sessionRepository.deleteMany(predicate: predicate)
        }
        
        if let _ = try sessionRepository.getOne(predicate: self.currentSessionPredicate) {
            print("Cannot start another session before stopped!")
            return
        } else {
            // Start new session
            do {
                let newSession = Session()
                newSession.start = Date()
                newSession.end = nil
                let targetEnd = NSDate().addMinutes(minutesToAdd: Settings.shared.sessionLengthInMinute
                )
                newSession.targetEnd = targetEnd as Date
                
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
            predicate: self.currentSessionPredicate
        ) else { return }
        
        // TODO: Stop timer here
        
        do {
            found.end = Date()
            let session = try self.sessionRepository.update(found)
            if let obey = session.isObey() {
                if obey {
                    let newHistory = PointHistory()
                    newHistory.amount = Int32(PointReward.success)
                    newHistory.createdAt = Date()
                    newHistory.action = PointActionType.restSuccess
                    
                    _ = try pointHistoryRepository.create(newHistory)
                    UserProfile.shared.addPoints(PointReward.success)
                }
            }
        } catch let error{
            self.abort()
            throw error
        }
        AVHelper.shared.end()
    }
    
    func getDayTotalTimeInMinute(_ date: Date = Date()) -> Int {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        let todayPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "end != nil"),
            NSPredicate(format: "%@ >= start", dateFrom as NSDate),
            NSPredicate(format: "start < %@", dateTo! as NSDate)
        ])
        
        do {
            let rows = try sessionRepository.getAll(predicate: todayPredicate)
            let res = rows.reduce(0) { $0 + (($1.end! - $1.start!).minute ?? 0) }
            return res
        } catch {
            return 0
        }
    }
    
    // TODO: Count here
    func countStreaks() -> Int {
        return 0
    }
    
}
