//
//  SessionHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import Combine

// Message for Frontend Timer
struct SessionMessage: Codable {
    var totalElapsedInSeconds: Int = 0
    var sessionElapsedInSeconds: Int = 0
    var running: Bool = false
}

// Will also function as timer facade
class SessionHelper {
    
    static let shared = SessionHelper()
    let sessionRepository = SessionRepository.shared
    
    // MARK: Const
    let minimumSessionCriteriaSeconds = 5
    
    // Predicate Helper
    let currentSessionPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "end == nil"),
        NSPredicate(format: "appSession == %@", Settings.shared.currentSessionStart as NSDate)
    ])
    let calendar: Calendar
    
    // Data Publisher
    var publisher: AnyPublisher<SessionMessage, Never> {
        publishedSubject.eraseToAnyPublisher()
    }
    private(set) var sessionMessage = SessionMessage() {
        didSet { publishedSubject.send(self.sessionMessage) }
    }
    private let publishedSubject = PassthroughSubject<SessionMessage, Never>()
    
    // Timer
    private var sessionTimer = Counter()
    private var sessionTimeSubscriber: AnyCancellable?
    
    private var totalWatchDaySeconds: Int = 0
    private var notificationCalled: Bool = false
    
    private init() {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        self.calendar = calendar
        
        // Init Subs to Counter
        self.sessionTimeSubscriber = sessionTimer.publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .finished:
                    break
                }
            },
            receiveValue: self.onTick
        )
        
        // Re-entry total watch time
        self.totalWatchDaySeconds = self.getDayTotalTimeInSecond()
    }
    
    private func onTick(_ timeElapsed: Int) {
        self.totalWatchDaySeconds += 1 // this maybe wont be accurate
        self.sessionMessage.sessionElapsedInSeconds = timeElapsed
        self.sessionMessage.totalElapsedInSeconds = self.totalWatchDaySeconds
        
        // Check for notification
        if !self.notificationCalled {
            let timeLimit = Settings.shared.sessionLengthInMinute * 60
            let reminderBeforeSeconds = 60
            if timeElapsed >= timeLimit - reminderBeforeSeconds {
                // Send notification request
                self.notificationCalled = true
                if Settings.shared.notificationType == NotificationPreferenceType.callNotif {
                    CallHelper.shared.call(delayInitialSeconds: 1.5, timeoutSeconds: 60.0)
                    self.callNotification()
                } else {
                    self.callNotification()
                }
            }
        }
    }
    
    private func callNotification() {
        NotificationHelper.shared.requestNotification(
            title: "Prepare to End Your Watching Session",
            body: "Your Time Limit is below 1 minute left!!",
            sound: .default,
            badge: 1,
            notificationType: .Local,
            category: Notification.Category.session,
            delayInitialSeconds: 1.5
        )
    }
    
    private func abort() {
        // Cancel Timer
        self.sessionTimer.end(value: 0)
        self.notificationCalled = false
        self.sessionMessage.running = false
        
        // Delete Session
        do {
            _ = try sessionRepository.deleteMany(predicate: NSPredicate(format: "end == nil"))
        } catch {
            print("Failed abort")
        }
    }
    
    func start() throws {
        // Check existing active session
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "end == nil"),
            NSPredicate(format: "appSession != %@", Settings.shared.currentSessionStart as NSDate)
        ])
        let founds = try sessionRepository.getAll(predicate: predicate)
        
        // Start Timer
        self.sessionTimer.start(0)
        self.sessionMessage.running = true
        
        if !founds.isEmpty {
            _ = try sessionRepository.deleteMany(predicate: predicate)
        }
        
        // MARK: Possible bug when app closed
        // Prevent starting session if a session is active
        if let _ = try sessionRepository.getOne(predicate: self.currentSessionPredicate) {
            print("Cannot start another session before stopped!")
            return
        } else {
            // Start new session
            self.notificationCalled = false
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
        // Must find an active session
        guard let found = try sessionRepository.getOneLastSession(isDone: false) else { return }
        
        // End timer
        self.sessionTimer.end()
        self.sessionMessage.running = false
        
        // Add to active session record
        do {
            found.end = Date()
            
            // MARK: probably need to add extra requirement because it can be abused lol (spam start/end)
            if (found.end! - found.start!).second! < minimumSessionCriteriaSeconds { // 5 seconds
                self.abort()
                return
            }
            
            if found.isObey()! {
                let lastSession = try sessionRepository.getOneLastSession(isDone: true)
                UserProfile.shared.accomplish += 1
                
                if let lastSessionFound = lastSession {
                    if lastSessionFound.isObey()! {
                        // add points streak
                        try PointHelper.shared.addPoints(action: PointActionType.restSuccessStreak)
                        
                        // add streak
                        found.streakCount = lastSessionFound.streakCount + 1
                        UserProfile.shared.streak = found.streakCount
                    } else {
                        // add points non-streak
                        try PointHelper.shared.addPoints(action: PointActionType.restSuccess)
                    }
                } else {
                    // add points non-streak
                    try PointHelper.shared.addPoints(action: PointActionType.restSuccess)
                }
            } else {
                // if failed
                UserProfile.shared.exceed += 1
                UserProfile.shared.streak = 0
            }
            
            _ = try self.sessionRepository.update(found)
        } catch let error{
            self.abort()
            throw error
        }
    }

    func getLifetimeTotalTimeInSecond() -> Int {
        do {
            let rows = try sessionRepository.getAll(predicate: NSPredicate(format: "end != nil"))
            let res: Int = rows.reduce(0) { $0 + (($1.end! - $1.start!).second!) }
            return res
        } catch {
            return 0
        }
    }
    
    func getDayFinishedSessions(_ date: Date = Date()) -> [Session] {
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        let todayPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "end != nil"),
            NSPredicate(format: "%@ >= start", dateFrom as NSDate),
            NSPredicate(format: "start < %@", dateTo! as NSDate)
        ])
        do {
            return try sessionRepository.getAll(predicate: todayPredicate)
        } catch {
            return []
        }
    }
    
    func getDayTotalTimeInSecond(_ date: Date = Date()) -> Int {
        let rows = self.getDayFinishedSessions(date)
        let res = rows.reduce(0) { $0 + (($1.end! - $1.start!).second ?? 0) }
        return res
    }
    
    func getDayTotalPoint(_ date: Date = Date()) -> Int {
        let rows = self.getDayFinishedSessions(date)
        let res = rows.reduce(0) { $0 + (
            $1.isObey()! ?
                $1.streakCount > 0 ? PointReward.restSuccessStreak : PointReward.restSuccess : 0
        ) }
        return res
    }

    func getDayTotalTimeInMinute(_ date: Date = Date()) -> Int {
        return self.getDayTotalTimeInSecond(date) / 60
    }
    
    
    // MARK: Down below is unfinished or ambiguous functions
    // TODO: Fix this pls
    
    func getDayStreak() {
        
    }
    
    private func evaluateDay(_ date: Date = Date()) {
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        if (date as NSDate).isLessThanDate(dateToCompare: dateTo! as NSDate) {
            print("Cannot evaluate non-passed day")
            return
        }
        // TODO: if failed target
    }
    
    
}
