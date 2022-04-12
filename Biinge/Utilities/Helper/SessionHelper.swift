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
    
    let currentSessionPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "end == nil"),
        NSPredicate(format: "appSession == %@", Settings.shared.currentSessionStart as NSDate)
    ])
    let calendar: Calendar
    
    private init() {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        self.calendar = calendar
    }
    
    private func abort() {
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
                    try PointHelper.shared.addPoints(action: PointActionType.restSuccess)
                }
            }
        } catch let error{
            self.abort()
            throw error
        }
    }

    func getLifetimeTotalTimeInMinute() -> Int {
        do {
            let rows = try sessionRepository.getAll(predicate: NSPredicate(format: "end != nil"))
            let res = rows.reduce(0) { $0 + (($1.end! - $1.start!).minute ?? 0) }
            return res
        } catch {
            return 0
        }
    }
    
    func getDayTotalTimeInMinute(_ date: Date = Date()) -> Int {
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
    
    func isDayUnderLimit(_ date: Date = Date()) -> Bool {
        let dateTotal = self.getDayTotalTimeInMinute(date)
        return dateTotal <= Settings.shared.targetMaxDailySessionInMinute
    }
    
    // MARK: Only invoke on streak adding
    private func evaluateDay(_ date: Date = Date()) {
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        if (date as NSDate).isLessThanDate(dateToCompare: dateTo! as NSDate) {
            print("Cannot evaluate non-passed day")
            return
        }
        
        if self.isDayUnderLimit(date) {
            do {
                try PointHelper.shared.addPoints(action: PointActionType.dailyTargetSuccess)
            } catch {
                
            }
        }
        
        // TODO: if failed target
    }
    
    // TODO: Count here
    func countStreaks() -> Int {
        return 0
    }
    
    
    
}
