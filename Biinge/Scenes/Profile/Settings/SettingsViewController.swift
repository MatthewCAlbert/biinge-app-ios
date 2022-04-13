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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func switchCall(_ sender: UISwitch) {
        if sender.isOn{
            Settings.shared.notificationType = NotificationPreferenceType.callNotif
        }else {
            Settings.shared.notificationType = NotificationPreferenceType.normalNotif
        }
    }
}
