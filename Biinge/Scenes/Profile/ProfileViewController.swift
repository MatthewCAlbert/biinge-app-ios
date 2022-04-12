//
//  ProfileViewController.swift
//  Biinge
//
//  Created by Vincentius Ian Widi Nugroho on 11/04/22.
//

import UIKit

class ProfileViewController: UIViewController {
    var image: UIImage = UIImage(data: UserProfile.shared.pic as Data)!
    var _accomplish: Int = UserProfile.shared.accomplish
    var _exceed: Int = UserProfile.shared.exceed
    var _point: Int = UserProfile.shared.points
    var _streak: Int = UserProfile.shared.streak
    var _username: String = UserProfile.shared.username!
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
        hour = SessionHelper.shared.getLifetimeTotalTimeInMinute()/60
        minute = SessionHelper.shared.getLifetimeTotalTimeInMinute()%60
        watchTotalLabel.text = "\(hour) hr \(minute) min"
        accomLabel.text = "\(_accomplish)/\(_accomplish+_exceed)"
        exceedLabel.text = "\(_exceed)/\(_accomplish+_exceed)"
        pointLabel.text = "\(_point) Points"
        streakLabel.text = "\(_streak) streaks in a row"
        userLabel.text = _username
        rankImage.image = UIImage(named:"piala.png")
        streakImage.image = UIImage(named:"api.png")
        watchImage.image = UIImage(named:"popcorn.png")
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
    
    func setView(view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 1
        view.layer.cornerRadius = 10
    }
    
    @IBAction func tapSettings() {

    }
    
    @IBAction func tapShare() {

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


