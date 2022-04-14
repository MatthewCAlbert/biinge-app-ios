//
//  SessionHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import Combine

enum SessionEndMessageType: Int {
    case none, failed, success, streak, timeUp
}

// Message for Session End
struct SessionEndMessage {
    let id = UUID()
    var type: SessionEndMessageType = SessionEndMessageType.none
}

// Message for Frontend Timer
struct SessionMessage: Codable {
    var sessionElapsedInSeconds: Int = 0
    var miniSessionElapsedInSeconds: Int = 0
    var isPaused: Bool = false
    var running: Bool = false
    var currentMiniSessionLengthSeconds: Int = 0
}

// Will also function as timer facade
class SessionHelper {
    
    static let shared = SessionHelper()
    let sessionRepository = SessionRepository.shared
    let pointHistoryRepository = PointHistoryRepository.shared
    
    // MARK: Const
    let minimumSessionCriteriaSeconds = 10
    
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
    let publishedEndSubject = PassthroughSubject<SessionEndMessage, Never>()
    
    // Timer
    private var sessionTimer = Counter()
    private var sessionTimeSubscriber: AnyCancellable?
    
    private var notificationCalled: Bool = false
    private var currentRunningSessionId: String?
    
    public var isLastMiniSession: Bool = false
    
    private init() {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.default
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
        UserProfile.shared.points = self.getLifetimeTotalPoint()
    }
    
    private func onTick(_ timeElapsed: Int) {
        self.sessionMessage.miniSessionElapsedInSeconds = timeElapsed
        self.sessionMessage.sessionElapsedInSeconds += 1
        
        // Check for notification
        if !self.notificationCalled && self.sessionMessage.miniSessionElapsedInSeconds > minimumSessionCriteriaSeconds {
            let timeLimit = self.sessionMessage.currentMiniSessionLengthSeconds
            let reminderBeforeSeconds = 45
            if timeElapsed >= (timeLimit - reminderBeforeSeconds) {
                // Send notification request
                self.notificationCalled = true
                
                var sessionEndMessageObj = SessionEndMessage()
                sessionEndMessageObj.type = SessionEndMessageType.timeUp
                self.publishedEndSubject.send(sessionEndMessageObj)
                
                if Settings.shared.notificationType == NotificationPreferenceType.callNotif {
                    CallHelper.shared.call(delayInitialSeconds: 1.5, timeoutSeconds: Double(reminderBeforeSeconds))
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
    
    // Start or resume
    func start() throws {
        // Check existing active session
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "end == nil"),
            NSPredicate(format: "appSession != %@", Settings.shared.currentSessionStart as NSDate)
        ])
        let founds = try sessionRepository.getAll(predicate: predicate)
        let sessionId = self.currentRunningSessionId
        
        // Start Timer
        if sessionId == nil {
            self.sessionMessage.sessionElapsedInSeconds = 0
        }
        
        self.sessionTimer.start(0)
        self.sessionMessage.isPaused = false
        self.sessionMessage.running = true
        self.isLastMiniSession = false
        
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
                newSession.sessionId = sessionId
                
                // Calculate left target with rest
                var availableRestSecond = Settings.shared.targetRestInMinute * 60
                if let sessionId = sessionId {
                    let commonSession = try sessionRepository.getAll(commonSessionId: sessionId)
                    let sessionSpent = commonSession.reduce(0) { $0 + ($1.end != nil ? ($1.end! - $1.start!).second! : 0) }
                    
                    let maxSessionLength = Settings.shared.sessionLengthInMinute * 60
                    // Is last session
                    if maxSessionLength - sessionSpent <= availableRestSecond {
                        availableRestSecond = maxSessionLength - sessionSpent
                        self.isLastMiniSession = true
                    }
                }
                self.sessionMessage.currentMiniSessionLengthSeconds = availableRestSecond
                
                let targetEnd = NSDate().addSeconds(secondsToAdd: availableRestSecond)
                newSession.targetEnd = targetEnd as Date
                
                let createdSession = try self.sessionRepository.create(newSession, enableHeadSessionId: true)
                self.currentRunningSessionId = createdSession.id
            } catch let error{
                self.currentRunningSessionId = nil
                self.abort()
                throw error
            }
        }
    }
    
    func autoDeterminePauseEnd() throws {
        if !self.isLastMiniSession {
            try self.pause()
        } else {
            try self.end()
        }
    }
    
    // Rest
    func pause() throws {
        // Must find an active session
        guard let found = try sessionRepository.getOneLastSession(isDone: false) else { return }
        
        // End timer
        self.sessionTimer.end()
        self.sessionMessage.miniSessionElapsedInSeconds = 0
        self.sessionMessage.isPaused = true
        
        // End call if any
        AppDelegate.shared.callManager.endFirst()
        
        // Add to active session record as PAUSED
        do {
            found.end = Date()
            var sessionEndMessageObj = SessionEndMessage()
            
            // MARK: probably need to add extra requirement because it can be abused lol (spam start/end)
            if (found.end! - found.start!).second! < minimumSessionCriteriaSeconds { // 5 seconds
                self.abort()
                publishedEndSubject.send(sessionEndMessageObj)
                return
            }
            
            if found.isObey()! {
                try PointHelper.shared.addPoints(action: PointActionType.restSuccess)
                sessionEndMessageObj.type = SessionEndMessageType.success
            }
        } catch let error{
            self.abort()
            throw error
        }
    }
    
    func end() throws {
        // Must find an active session
        guard let found = try sessionRepository.getOneLastSession(isDone: false) else { return }
        
        // End timer
        self.sessionTimer.end()
        self.sessionMessage.running = false
        self.sessionMessage.sessionElapsedInSeconds = 0
        self.currentRunningSessionId = nil
        self.isLastMiniSession = false
        
        // End call if any
        AppDelegate.shared.callManager.endFirst()
        
        // Add to active session record
        do {
            found.end = Date()
            var sessionEndMessageObj = SessionEndMessage()
            
            // MARK: probably need to add extra requirement because it can be abused lol (spam start/end)
            if (found.end! - found.start!).second! < minimumSessionCriteriaSeconds { // 5 seconds
                self.abort()
                publishedEndSubject.send(sessionEndMessageObj)
                return
            }
            
            if found.isObey()! {
                let lastSession = try sessionRepository.getOneLastSession(isDone: true)
                UserProfile.shared.accomplish += 1
                
                // add points streak
                try PointHelper.shared.addPoints(action: PointActionType.sessionSuccess)
                sessionEndMessageObj.type = SessionEndMessageType.streak
                
                if let lastSessionFound = lastSession {
                    if lastSessionFound.isObey()! {
                        // add streak
                        found.streakCount = lastSessionFound.streakCount + 1
                        UserProfile.shared.streak = found.streakCount
                    }
                }
            } else {
                // if failed
                UserProfile.shared.exceed += 1
                UserProfile.shared.streak = 0
                sessionEndMessageObj.type = SessionEndMessageType.failed
            }
            
            _ = try self.sessionRepository.update(found)
            publishedEndSubject.send(sessionEndMessageObj)
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
    
    func getLifetimeTotalPoint() -> Int {
        do {
            let rows = try pointHistoryRepository.getAll(predicate: nil)
            let res = rows.reduce(0) { $0 + $1.amount }
            return Int(res)
        } catch {
            return 0
        }
    }
    
    func getDayStartEnd(_ date: Date = Date()) -> (NSDate, NSDate) {
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        return (dateFrom as NSDate, dateTo! as NSDate)
    }
    
    func getFinishedSessions(_ date: Date? = nil, aggregateBreak: Bool = false) -> [Session] {
        var predicate = [
            NSPredicate(format: "end != nil")
        ]
        if let date = date {
            let (dateFrom, dateTo) = self.getDayStartEnd(date)
            predicate.append(NSPredicate(format: "start >= %@", dateFrom))
            predicate.append(NSPredicate(format: "end < %@", dateTo))
        }
        let sortDescriptors = [
            NSSortDescriptor(key: "start", ascending: true)
        ]
        
        do {
            let rows = try sessionRepository.getAll(predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicate), sortDescriptors: sortDescriptors)
            if !aggregateBreak {
                return rows
            }
            
            // Aggregate Rows
            if rows.isEmpty {
                return []
            }
            
            var newRows = [Session]()
            var lastSessionId: String?
            for row in rows {
                if let lastSessionId = lastSessionId {
                    if lastSessionId != row.sessionId {
                        newRows.append(row)
                    } else {
                        // Same then shift end & targetEnd
                        newRows.last?.end = row.end
                        newRows.last?.targetEnd = row.targetEnd
                        newRows.last?.streakCount = row.streakCount
                    }
                } else{
                    newRows.append(row)
                }
                lastSessionId = row.sessionId!
            }
            return newRows
        } catch {
            return []
        }
    }
    
    func getDayPointHistory(_ date: Date = Date()) -> [PointHistory] {
        let (dateFrom, dateTo) = self.getDayStartEnd(date)

        let todayPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "createdAt >= %@", dateFrom ),
            NSPredicate(format: "createdAt < %@", dateTo)
        ])
        
        do {
            let rows = try pointHistoryRepository.getAll(predicate: todayPredicate)
            return rows
        } catch {
            return []
        }
    }
    
    func getDayDoneSessionSuccessAndFail(_ date: Date = Date()) -> (Int, Int) {
        let rows = self.getFinishedSessions(date, aggregateBreak: true)
        var accPerDay: Int = 0
        var excPerDay: Int = 0
        for row in rows {
            if row.isObey()! {
                accPerDay += 1
            } else {
                excPerDay += 1
            }
        }
        return (accPerDay, excPerDay)
    }
  
    func getDayTotalTimeInSecond(_ date: Date = Date()) -> Int {
        let rows = self.getFinishedSessions(date)
        let res = rows.reduce(0) { $0 + (($1.end! - $1.start!).second ?? 0) }
        return res
    }
    
    func getDayTotalPoint(_ date: Date = Date()) -> Int {
        let rows = self.getDayPointHistory(date)
        let res = rows.reduce(0) { $0 + $1.amount }
        return Int(res)
    }
    
    func getDayStreak(_ date: Date = Date()) -> Int {
        let rows = self.getFinishedSessions(date, aggregateBreak: true)
        let res = rows.reduce(0) { $0 + (
            $1.isObey()! ?
                $1.streakCount > 0 ? 1 : 0 : 0
        ) }
        return res
    }

    func getDayTotalTimeInMinute(_ date: Date = Date()) -> Int {
        return self.getDayTotalTimeInSecond(date) / 60
    }
    
    
}
