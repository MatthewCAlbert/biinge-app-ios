//
//  HomeViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Var for indicator & message
    var watchLimit: String?
    var breakLimit: String?
    var watchLimitMessage: String?
    var breakLimitMessage: String?
    
    //Var for countdown timer
    var watchTimer = Timer()
    var breakTimer = Timer()
    var watchHours: Int = 0
    var watchMinutes: Int = 0
    var watchSeconds: Int = 0
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    
    //
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    @IBOutlet weak var watchReminderLabel: UILabel!
    @IBOutlet weak var breakReminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchTimeLabel.text = watchLimit
        breakTimeLabel.text = breakLimit
        
        watchReminderLabel.text = watchLimitMessage
        breakReminderLabel.text = breakLimitMessage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        breakTimeLabel.isHidden = true
        breakReminderLabel.isHidden = true
    }
    
    @IBAction func didUnwindFromSetTimeVC(_ sender: UIStoryboardSegue) {
        watchTimeLabel.text = watchLimit
        breakTimeLabel.text = breakLimit
        
        watchReminderLabel.text = watchLimitMessage
        breakReminderLabel.text = breakLimitMessage
        
    }
    
    @IBAction func changeModePressed(_ sender: UIButton) {
        if breakTimeLabel.isHidden == true {
            breakTimeLabel.isHidden = false
            breakReminderLabel.isHidden = false
            
            watchTimeLabel.isHidden = true
            watchReminderLabel.isHidden = true
        } else {
            breakTimeLabel.isHidden = true
            breakReminderLabel.isHidden = true
            
            watchTimeLabel.isHidden = false
            watchReminderLabel.isHidden = false
        }
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        watchHours = (Settings.shared.sessionLengthInMinute) / 60
        watchMinutes = (Settings.shared.sessionLengthInMinute) % 60
        breakMinutes = Settings.shared.targetRestInMinute % 60
        
        
        watchTimer.invalidate()
        breakTimer.invalidate()
        watchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWatchTimer), userInfo: nil, repeats: true)
        breakTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBreakTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateWatchTimer() {
        if self.watchSeconds > 0 {
            self.watchSeconds -= 1
        } else if self.watchMinutes > 0 && self.watchSeconds == 0 {
            self.watchMinutes -= 1
            self.watchSeconds = 59
        } else if self.watchHours > 0 && self.watchMinutes == 0 && self.watchSeconds == 0 {
            self.watchHours -= 1
            self.watchMinutes = 59
            self.watchSeconds = 59
        }
        watchTimeLabel.text = String(format: "%02d:%02d:%02d", watchHours, watchMinutes, watchSeconds)
    }
    
    @objc func updateBreakTimer() {
        if self.breakSeconds > 0 {
            self.breakSeconds -= 1
        } else if self.breakMinutes > 0 && self.breakSeconds == 0 {
            self.breakMinutes -= 1
            self.breakSeconds = 59
        }
        breakTimeLabel.text = String(format: "%02d:%02d", breakMinutes, breakSeconds)
    }
    
}


