//
//  NotificationHelper.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation
import UIKit
import UserNotifications

// TODO: Create Notif Category & Actions
struct Notification {
    struct Category {
        static let tutorial = "tutorial"
    }
    
    struct Action {
        static let readLater = "readLater"
        static let showDetails = "showDetails"
        static let unsubscribe = "unsubscribe"
    }
}

enum NotificationType: String {
    case Local, Scheduled, Image
}

class NotificationHelper: NSObject {
    
    static let shared = NotificationHelper()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override private init() {
        super.init()
        configureUserNotificationsCenter()
    }
    
    // TODO: Create Notif Category & Actions
    private func configureUserNotificationsCenter() {
        notificationCenter.delegate = self
        
        // Define Actions
        let actionReadLater = UNNotificationAction(identifier: Notification.Action.readLater, title: "Read Later", options: [])
        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.showDetails, title: "Show Details", options: [.foreground])
        let actionUnsubscribe = UNNotificationAction(identifier: Notification.Action.unsubscribe, title: "Unsubscribe", options: [.destructive, .authenticationRequired])
        
        // Define Category
        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionReadLater, actionShowDetails, actionUnsubscribe], intentIdentifiers: [], options: [])
        
        // Register Category
        notificationCenter.setNotificationCategories([tutorialCategory])
    }
    
    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    func getNotificationSettings() {
        self.notificationCenter.getNotificationSettings { (notificationSettings)  in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    print("The application is allowed to display notifications")
                })
            case .authorized:
                print("The application is allowed to display notifications")
            case .denied:
                print("The application not allowed to display notifications")
            case .provisional:
                print("The application authorized to post non-interruptive user notifications")
            case .ephemeral:
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    // TODO: Modify to enable multiple category & customized props, probably add another function extension
    func requestNotification(title: String, body: String, sound: UNNotificationSound, badge: Int, notificationType: NotificationType) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = NSNumber(value: badge)
        content.categoryIdentifier = Notification.Category.tutorial
        let identifier = notificationType
        var request = UNNotificationRequest(identifier: notificationType.rawValue, content: content, trigger: nil)
        if notificationType == NotificationType.Local {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)
        } else if notificationType == NotificationType.Scheduled {
            let date = Date(timeIntervalSinceNow: 5)
            let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)
        } else {
            // TODO: Remove this later (unused and no resource here)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            if let url = Bundle.main.url(forResource: "octo",
                                         withExtension: "png") {
                if let attachment = try? UNNotificationAttachment(identifier: identifier.rawValue,
                                                                  url: url,
                                                                  options: nil)
                {
                    content.attachments = [attachment]
                }
            }
            request = UNNotificationRequest(identifier: identifier.rawValue, content: content, trigger: trigger)
        }
        
        self.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("Notif dispatched")
            }
        }
    }
    
    // MARK: Example Only
    private func exampleCall() {
        // Instant
        self.requestNotification(title: NotificationType.Local.rawValue, body: "This is example how to create " + "\(NotificationType.Local) Notifications", sound: .default, badge: 1, notificationType: .Local)
        
        // Scheduled
        self.requestNotification(title: NotificationType.Scheduled.rawValue, body: "This is example how to create " + "\(NotificationType.Scheduled) Notifications", sound: .default, badge: 1, notificationType: .Scheduled)
        
        // With Image
        self.requestNotification(title: NotificationType.Image.rawValue, body: "This is example how to create " + "\(NotificationType.Image) Notifications", sound: .default, badge: 1, notificationType: .Image)
    }
    
}

// Handle Notification Request
extension NotificationHelper: UNUserNotificationCenterDelegate {
    
    // Show Notification as Alert (List & Banner)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14, *) {
            completionHandler([.list, .banner])
        } else {
            completionHandler([.alert])
        }
    }
    
    // Handle Action Taken from Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let category = response.notification.request.content.categoryIdentifier
        print(category)
        switch response.actionIdentifier {
        case Notification.Action.readLater:
            print("Save Tutorial For Later")
        case Notification.Action.unsubscribe:
            print("Unsubscribe Reader")
        default:
            print("Show Details")
        }
        completionHandler()
    }

}
