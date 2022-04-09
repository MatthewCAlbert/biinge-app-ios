//
//  Settings.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

enum NotificationType: String, CaseIterable {
    case callNotif = "CallNotification"
    case normalNotif = "NormalNotification"
}

enum SettingType: String, CaseIterable {
    case notificationType = "NotificationType"
    case targetMaxDailySessionInMinute = "TargetMaxDailySessionInMinute"
    case sessionLengthInMinute = "SessionLengthInMinute"
    case targetRestInMinute = "TargetRestInMinute"
}

class Settings {
    
    private var _notificationType: NotificationType? = nil
    private var _targetMaxDailySessionInMinute: Int = 0
    private var _sessionLengthInMinute: Int = 0
    private var _targetRestInMinute: Int = 0
    
    static let shared = Settings()
    
    private init() {
        if let notificationType = UserDefaults.standard.string(forKey: SettingType.notificationType.rawValue) {
            self._notificationType = NotificationType(rawValue: notificationType)
        } else {
            self.notificationType = NotificationType.callNotif
        }

        let targetMaxDailySessionInMinute = UserDefaults.standard.integer(forKey: SettingType.targetMaxDailySessionInMinute.rawValue)
        if targetMaxDailySessionInMinute > 0 {
            self._targetMaxDailySessionInMinute = targetMaxDailySessionInMinute
        } else {
            self.targetMaxDailySessionInMinute = 120
        }

        let sessionLengthInMinute = UserDefaults.standard.integer(forKey: SettingType.sessionLengthInMinute.rawValue)
        if sessionLengthInMinute > 0 {
            self._sessionLengthInMinute = sessionLengthInMinute
        } else {
            self.sessionLengthInMinute = 25
        }
        
        let targetRestInMinute = UserDefaults.standard.integer(forKey: SettingType.targetRestInMinute.rawValue)
        if targetRestInMinute > 0 {
            self._targetRestInMinute = targetRestInMinute
        } else {
            self.targetRestInMinute = 5
        }
        
    }
    
    static func getInstance() -> Settings {
        return shared
    }
    
    var notificationType: NotificationType? {
        get {
            return self._notificationType
        }
        set(newValue) {
            self._notificationType = newValue
            UserDefaults.standard.set(newValue, forKey: SettingType.notificationType.rawValue)
        }
    }

    var targetMaxDailySessionInMinute: Int {
        get {
            return self._targetMaxDailySessionInMinute
        }
        set(newValue) {
            self._targetMaxDailySessionInMinute = newValue
            UserDefaults.standard.set(newValue, forKey: SettingType.targetMaxDailySessionInMinute.rawValue)
        }
    }
    
    var sessionLengthInMinute: Int {
        get {
            return self._sessionLengthInMinute
        }
        set(newValue) {
            self._sessionLengthInMinute = newValue
            UserDefaults.standard.set(newValue, forKey: SettingType.sessionLengthInMinute.rawValue)
        }
    }
    
    var targetRestInMinute: Int {
        get {
            return self._targetRestInMinute
        }
        set(newValue) {
            self._targetRestInMinute = newValue
            UserDefaults.standard.set(newValue, forKey: SettingType.targetRestInMinute.rawValue)
        }
    }
    
}
