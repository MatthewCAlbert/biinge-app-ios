//
//  TestViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import UIKit
import UserNotifications

class TestViewController: UIViewController {

    @IBOutlet weak var statusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Task {
            await self.printStatus()
        }
        
        // TODO: Remove this later
        AVHelper.shared.start()
    }
    
    private func printStatus() async {
        let result: UNNotificationSettings = await NotificationHelper.shared.notificationCenter.notificationSettings()
        switch result.authorizationStatus {
        case .notDetermined:
            NotificationHelper.shared.requestAuthorization(completionHandler: { (success) in
                guard success else { return }
                print("The application is allowed to display notifications")
            })
            self.statusLbl.text = "Not Determined"
        case .authorized:
            self.statusLbl.text = "Authorized"
        case .denied:
            self.statusLbl.text = "Not Alllowed"
        case .provisional:
            self.statusLbl.text = "Provisional"
        case .ephemeral:
            self.statusLbl.text = "Ephemeral"
        @unknown default:
            print("Application Not Allowed to Display Notifications")
            self.statusLbl.text = "Not Alllowed"
        }
    }
    
    // UNMutableNotificationContent
    @IBAction func OnSatuPressed(_ sender: UIButton) {
    }
    
    @IBAction func TriggerNormalNotif(_ sender: UIButton) {
        NotificationHelper.shared.requestNotification(
            title: NotificationType.Local.rawValue,
            body: "This is example how to create " + "\(NotificationType.Local) Notifications",
            sound: .default,
            badge: 1,
            notificationType: .Local,
            category: Notification.Category.session
        )
    }

    @IBAction func TriggerCallNotif(_ sender: UIButton) {
    }
}
