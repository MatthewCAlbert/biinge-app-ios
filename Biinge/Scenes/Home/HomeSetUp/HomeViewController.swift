//
//  HomeViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    //Var for indicator & message
    var watchLimit: String?
    var breakLimit: String?
    var watchLimitMessage: String?
    var breakLimitMessage: String?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    @IBOutlet weak var watchReminderLabel: UILabel!
    @IBOutlet weak var breakReminderLabel: UILabel!
    
    @IBOutlet weak var timerStartEndBtn: UIButton!
    @IBOutlet weak var setTimeBtn: UIButton!
    
    // MARK: Reactive Timer
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    private func updateWatchTimer(_ seconds: Int) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds)
        watchTimeLabel.text = String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    private func updateBreakTimer(_ seconds: Int) {
        let (h, m, s) = self.secondsToHoursMinutesSeconds(seconds)
        breakTimeLabel.text = String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    var sessionSubscriber: AnyCancellable?

    
    // MARK: UI Lifecycle + Trigger
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchTimeLabel.text = watchLimit
        breakTimeLabel.text = breakLimit
        
        watchReminderLabel.text = watchLimitMessage
        breakReminderLabel.text = breakLimitMessage
        
        usernameLabel.text = "Hi, \(UserProfile.shared.username ?? "Watcher")!"
        
        self.sessionSubscriber = SessionHelper.shared.publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .finished:
                    break
                }
            },
            receiveValue: { sessionMessage in
                let timeLimit = Settings.shared.sessionLengthInMinute * 60
                self.updateWatchTimer(timeLimit - sessionMessage.sessionElapsedInSeconds)
                self.updateBreakTimer(sessionMessage.totalElapsedInSeconds)
                
                if sessionMessage.running && self.timerStartEndBtn.title(for: .normal) != "End" {
                    self.timerStartEndBtn.setTitle("End", for: .normal)
                } else if !sessionMessage.running && self.timerStartEndBtn.title(for: .normal) != "Start" {
                    self.timerStartEndBtn.setTitle("Start", for: .normal)
                }
                
                if self.setTimeBtn.isEnabled && sessionMessage.running {
                    self.setTimeBtn.isEnabled = false
                } else if !self.setTimeBtn.isEnabled && !sessionMessage.running {
                    self.setTimeBtn.isEnabled = true
                }
            }
        )
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
        do {
            if !SessionHelper.shared.sessionMessage.running {
                try SessionHelper.shared.start()
            } else {
                try SessionHelper.shared.end()
            }
        } catch {
            
        }
    }
    
}


