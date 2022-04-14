//
//  SetTimeViewController.swift
//  Biinge
//
//  Created by Zidan Ramadhan on 08/04/22.
//

import UIKit
import Combine

class SetTimeViewController: UIViewController {
    
    @IBOutlet weak var watchTimePicker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var breakTimePicker: UIPickerView!
    
    let breakChoice = ["01", "02", "15", "20", "30", "45", "60"]
    var strBreakTime: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breakTimePicker.dataSource = self
        breakTimePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentSessionLength = Settings.shared.sessionLengthInMinute * 60
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let (h, m, _) = (currentSessionLength / 3600, (currentSessionLength % 3600) / 60, (currentSessionLength % 3600) % 60)
        let date = dateFormatter.date(from: "\(h):\(m)")
        watchTimePicker.date = date!
        
        self.setBreakDefaultValue(item: String(Settings.shared.targetRestInMinute))
    }
    
    func setBreakDefaultValue(item: String){
        if let indexPosition = breakChoice.firstIndex(of: item){
            breakTimePicker.selectRow(indexPosition, inComponent: 0, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeVC = segue.destination as? HomeViewController else { return }
        
        //Format for Watch Limit Time Indicator
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let strLimitTime = timeFormatter.string(from: watchTimePicker.date)
        
        //Set Time Indicator
        homeVC.watchLimit = strLimitTime
        homeVC.breakLimit = "\(strBreakTime):00"
        
        //Format for Watch Time Limit Message
        let hoursLimitFormatter = DateFormatter()
        hoursLimitFormatter.dateFormat = "HH"
        let hoursWatchLimitTime = hoursLimitFormatter.string(from: watchTimePicker.date)
        
        let minutesLimitFormatter = DateFormatter()
        minutesLimitFormatter.dateFormat = "mm"
        let minutesWatchLimitTime = minutesLimitFormatter.string(from: watchTimePicker.date)
        
        
        //Set Time Limit Message
        SetTimerRelay.shared.sessionMessage.watchReminderLabel = "remaining from \(hoursWatchLimitTime)h \(minutesWatchLimitTime)m of your watch time limit"
        SetTimerRelay.shared.sessionMessage.breakReminderLabel = "minutes remaining from \(strBreakTime) minutes of your break time"
        
        let totalWatchMinutes = (Int(hoursWatchLimitTime) ?? 0) * 60 + (Int(minutesWatchLimitTime) ?? 0)
        
        var decidedBreak = Int(strBreakTime) ?? 0
        if decidedBreak < 1 {
            decidedBreak = 1
        }
        
        Settings.shared.sessionLengthInMinute = totalWatchMinutes
        Settings.shared.targetRestInMinute = decidedBreak
        SetTimerRelay.shared.sessionMessage.sessionTimerLimitSeconds = totalWatchMinutes * 60
        SetTimerRelay.shared.sessionMessage.breakTimerLimitSeconds = decidedBreak
        
        
    }
    
}


//MARK: - Extension for custom picker
extension SetTimeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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



