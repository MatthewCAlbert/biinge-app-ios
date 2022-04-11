//
//  UserProfile.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 09/04/22.
//

import Foundation

class UserProfile {
    
    private var _id: String?
    private var _username: String?
    private var _points: Int
    
    static let shared = UserProfile()
    
    private init() {
        
        if let id = UserDefaults.standard.string(forKey: "userId") {
            self._id = id
        } else {
            let generatedId = UUID().uuidString
            UserDefaults.standard.set(generatedId, forKey: "userId")
        }
        
        self._username = UserDefaults.standard.string(forKey: "username")
        self._points = UserDefaults.standard.integer(forKey: "userPoints")
        
    }
    
    var id: String? {
        get {
            return self._id
        }
        set {
            return
        }
    }
    
    var username: String? {
        get {
            return self._username
        }
        set(newValue) {
            self._username = newValue
            UserDefaults.standard.set(newValue, forKey: "username")
        }
    }
    
    var points: Int {
        get {
            return self._points
        }
        set(newValue) {
            self._points = newValue
            UserDefaults.standard.set(newValue, forKey: "userPoints")
        }
    }
    
    func addPoints(_ value: Int) {
        self.points = self.points + value
    }
    
    func removePoints(_ value: Int) {
        self.points = self.points - value
    }
    
}
