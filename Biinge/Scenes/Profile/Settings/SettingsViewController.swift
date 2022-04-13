//
//  SettingsViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 13/04/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var stgLbl: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var notifPermissionLbl: UILabel!
    @IBOutlet weak var instructionNotifLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.instructionNotifLbl.isHidden = true
        self.switchControl.isOn = Settings.shared.notificationType == NotificationPreferenceType.callNotif
        
        Task {
            await self.printStatus()
        }
    }
    
    private func printStatus() async {
        let result: UNNotificationSettings = await NotificationHelper.shared.notificationCenter.notificationSettings()
        switch result.authorizationStatus {
        case .notDetermined:
            self.instructionNotifLbl.isHidden = false
            NotificationHelper.shared.requestAuthorization(completionHandler: { (success) in
                guard success else { return }
                print("The application is allowed to display notifications")
                self.instructionNotifLbl.isHidden = true
            })
            self.notifPermissionLbl.text = "Not Determined"
        case .authorized:
            self.notifPermissionLbl.text = "Authorized"
        case .denied:
            self.notifPermissionLbl.text = "Not Alllowed"
            self.instructionNotifLbl.isHidden = false
        case .provisional:
            self.notifPermissionLbl.text = "Provisional"
        case .ephemeral:
            self.notifPermissionLbl.text = "Ephemeral"
        @unknown default:
            print("Application Not Allowed to Display Notifications")
            self.notifPermissionLbl.text = "Not Alllowed"
        }
    }

    @IBAction func switchCall(_ sender: UISwitch) {
        if sender.isOn{
            Settings.shared.notificationType = NotificationPreferenceType.callNotif
        }else {
            Settings.shared.notificationType = NotificationPreferenceType.normalNotif
        }
    }
    @IBAction func resetOnboardingAction(_ sender: UIButton) {
        Settings.shared.onboardingDone = OnboardingStatus.notDone
        Toast.show(message: "Onboarding will be opened when you relaunch the app", controller: self)
    }
    @IBAction func exitAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
