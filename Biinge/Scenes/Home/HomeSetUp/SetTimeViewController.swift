//
//  SetTimeViewController.swift
//  Biinge
//
//  Created by Zidan Ramadhan on 08/04/22.
//

import UIKit

class SetTimeViewController: UIViewController {
    
    
    @IBOutlet weak var watchTimePicker: UIDatePicker!
    @IBOutlet weak var breakTimePicker: UIDatePicker!
    @IBOutlet weak var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton.layer.cornerRadius = 30
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let homeVC = segue.destination as? HomeViewController else { return }
        //Format for Time Indicator
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let strLimitTime = timeFormatter.string(from: watchTimePicker.date)
        let strBreakTime = timeFormatter.string(from: breakTimePicker.date)
        
        //Set Time Indicator
        homeVC.watchLimit = strLimitTime
        homeVC.breakLimit = strBreakTime
        
        //Format for Time Limit Messagminutes remaining from 30 minutes of your break time
        let hoursLimitFormatter = DateFormatter()
        hoursLimitFormatter.dateFormat = "HH"
        let minutesLimitFormatter = DateFormatter()
        minutesLimitFormatter.dateFormat = "mm"
        
        let hoursWatchLimitTime = hoursLimitFormatter.string(from: watchTimePicker.date)
        let minutesWatchLimitTime = minutesLimitFormatter.string(from: watchTimePicker.date)
        let hoursBreakLimitTime = hoursLimitFormatter.string(from: breakTimePicker.date)
        let minutesBreakLimitTime = minutesLimitFormatter.string(from: breakTimePicker.date)
        
//        let hoursWatchLimitCount = Int(hoursWatchLimitTime)
//        let minuteWatchLimitCount = Int(minutesWatchLimitTime)
//        let hoursBreakLimitCount = Int(hoursBreakLimitTime)
//        let minutesBreakLimitCount = Int(minutesBreakLimitTime)
//        
        
        //Set Time Limit Message
        homeVC.watchLimitMessage = "remaining from \(hoursWatchLimitTime)h \(minutesWatchLimitTime)m of your watch time limit"
        homeVC.breakLimitMessage = "minutes remaining from \(minutesBreakLimitTime) minutes of your break time"
    }
    
}
