//
//  DefaultReminderViewController.swift
//  Biinge
//
//  Created by Zidan Ramadhan on 08/04/22.
//

import UIKit

class DefaultReminderViewController: UIViewController {
    
    @IBOutlet weak var watchTimePicker: UIDatePicker!
    @IBOutlet weak var breakTimePicker: UIPickerView!
    
    let breakChoice = ["15", "20", "30", "45", "60"]
    var strBreakTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakTimePicker.dataSource = self
        breakTimePicker.delegate = self
    }
    
    
    @IBAction func setPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTabBar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTabBar" {
            //Format for Watch Limit Time Indicator
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let strLimitTime = timeFormatter.string(from: watchTimePicker.date)

            //Set Time Indicator
            UserDefaults.standard.set(strLimitTime, forKey: "watchLimit")
            UserDefaults.standard.set("\(strBreakTime):00", forKey: "breakLimit")
            
            //Format for Watch Time Limit Message
            let hoursLimitFormatter = DateFormatter()
            hoursLimitFormatter.dateFormat = "HH"
            let hoursWatchLimitTime = hoursLimitFormatter.string(from: watchTimePicker.date)

            let minutesLimitFormatter = DateFormatter()
            minutesLimitFormatter.dateFormat = "mm"
            let minutesWatchLimitTime = minutesLimitFormatter.string(from: watchTimePicker.date)
            
            //Set Time Limit Message
            UserDefaults.standard.set("remaining from \(hoursWatchLimitTime)h \(minutesWatchLimitTime)m of your watch time limit", forKey: "watchLimitMessage")
            UserDefaults.standard.set("minutes remaining from \(strBreakTime) minutes of your break time", forKey: "breakLimitMessage")

            let totalWatchMinutes = (Int(hoursWatchLimitTime) ?? 0) * 60 + (Int(minutesWatchLimitTime) ?? 0)

            Settings.shared.sessionLengthInMinute = totalWatchMinutes
            Settings.shared.targetRestInMinute = Int(strBreakTime) ?? 0
        }
    }
    
    
    
}

//MARK: - Extension for custom picker
extension DefaultReminderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakChoice.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breakChoice[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strBreakTime = breakChoice[row]
    }
    
}
