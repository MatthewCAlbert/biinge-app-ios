//
//  ProfileViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 11/04/22.
//

import UIKit

class ProfileViewController: UIViewController {

    var image: UIImage = UIImage(data: UserProfile.shared.pic as Data) ?? UIImage(named: "PersonPlaceholder")!
    var _accomplish: Int = 0
    var _exceed: Int = 0
    var _point: Int = 0
    var _streak: Int = 0
    var _username: String = ""
    var hour: Int = 0
    var minute: Int = 0
    
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var streakImage: UIImageView!
    @IBOutlet weak var watchImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoView2: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var circleProgress: CircularProgressView!
    
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var infoStack2: UIStackView!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var accomLabel: UILabel!
    @IBOutlet weak var exceedLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var watchTotalLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(view: infoView)
        setView(view: infoView2)
        setView(view: profileView)
        infoView2.addSubview(infoStack2)
        NSLayoutConstraint.activate([
            infoStack2.centerYAnchor.constraint(equalTo: infoView2.centerYAnchor),
            infoStack.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
        profileImage.image = image
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor(rgb: 0x8D8D92).cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadProfileData()
    }
    
    func loadProfileData() {
        self._accomplish = UserProfile.shared.accomplish
        self._exceed = UserProfile.shared.exceed
        self._point = UserProfile.shared.points
        self._streak = UserProfile.shared.streak
        self._username = UserProfile.shared.username ?? "No Username"
        
        let lifetimeTotalWatchtime = SessionHelper.shared.getLifetimeTotalTimeInSecond()
        (hour, minute, _) = (lifetimeTotalWatchtime / 3600, (lifetimeTotalWatchtime % 3600) / 60, (lifetimeTotalWatchtime % 3600) % 60)
        
        watchTotalLabel.text = "\(hour) hr \(minute) min"
        accomLabel.text = "\(_accomplish)/\(_accomplish+_exceed)"
        exceedLabel.text = "\(_exceed)/\(_accomplish+_exceed)"
        pointLabel.text = "\(_point) Points"
        streakLabel.text = "\(_streak) streaks in a row"
        userLabel.text = _username
        rankImage.image = UIImage(named:"piala.png")
        streakImage.image = UIImage(named:"api.png")
        watchImage.image = UIImage(named:"popcorn.png")
    }
    
    func setView(view: UIView){
        // corner radius
        view.layer.cornerRadius = 10

        // border
        view.layer.borderWidth = 0.0
        view.layer.borderColor = UIColor.black.cgColor

        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 6.0
    }
    
    @IBAction func tapSettings() {

    }
    
}


