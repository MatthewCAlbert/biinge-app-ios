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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    @IBOutlet weak var watchReminderLabel: UILabel!
    @IBOutlet weak var breakReminderLabel: UILabel!
    
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
    
    let cancellable = SessionHelper.shared.sessionElapsed.publisher.sink(
        receiveCompletion: { completion in
            switch completion {
                case .finished:
                break
            }
        },
        receiveValue: { repo in
            print(repo)
        }
    )

    
    // MARK: UI Lifecycle + Trigger
    
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
        _ = SessionHelper.shared.sessionElapsed.value
    }
    
}


