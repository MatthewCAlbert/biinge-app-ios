//
//  HomeViewController.swift
//  biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit

class HomeViewController: UIViewController {

    var watchLimit: String?
    
    @IBOutlet weak var hiUsernameLabel: UILabel!
    @IBOutlet weak var homeMessageLabel: UILabel!
    @IBOutlet weak var timerLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.setTitle(watchLimit, for: .normal)
    }
    

    @IBAction func startTimerPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func setTimerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSetTimer", sender: self)
    }
    
}

