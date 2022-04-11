//
//  HomeViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit

class HomeViewController: UIViewController {
    

    var watchLimit: String?
    var breakLimit: String?
    var watchLimitMessage: String?
    var breakLimitMessage: String?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var watchTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    
    @IBOutlet weak var watchReminderLabel: UILabel!
    @IBOutlet weak var breakReminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        breakTimeLabel.isHidden = true
        breakReminderLabel.isHidden = true

    }
    
    @IBAction func didUnwindFromSetTimeVC(_ sender: UIStoryboardSegue) {
       // guard let setTimeVC = sender.source as? SetTimeViewController else { return }
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
    
    
}

