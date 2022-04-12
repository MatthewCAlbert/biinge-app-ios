//
//  WelcomeViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 11/04/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    var logoOnBoards : [UIImage] = [UIImage(named: "Onboard1-1.png")!,UIImage(named: "Onboard2.png")!,UIImage(named: "Onboard3.png")!]
    var titleIntros : [String] = ["Welcome","Reward Over Effort","Share To Inspire"]
    var textOnBoards : [String] = ["Hey, I'm Bibi from Biinge, your personal watch manager! I will help to remind your binge-watching limit time, remind you to take a break for a short period of time, while challenging you to have a better binge-watching habit!","Bibi likes to reward herself as a accomplishment, how about we reward ourselves too? Earn points as the reward of achieving the goals to take a break and obey the time you set!","Bibi proud to share what she's being up to others, she wants you to be proud too! Share your binge-watching achievement with friends to get motivated and encouraged."]
    
    // buat control data
      var currentPage = 0
      
    
    //buat Outlet
    @IBOutlet weak var logoOnBoard: UIImageView!
    @IBOutlet weak var titleIntro: UILabel!
    @IBOutlet weak var textOnBoard: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoOnBoard.image = logoOnBoards[currentPage]
        titleIntro.text = titleIntros[currentPage]
        textOnBoard.text = textOnBoards[currentPage]
        

                NotificationCenter.default.addObserver(self, selector: #selector(changeTextBoard), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    @IBAction func buttonNext(_ sender: Any) {
        if currentPage ==  logoOnBoards.count-1 {
            currentPage = 0
        } else {
            currentPage += 1
        }
        changeBoard()
        
    }
    
    @objc func changeTextBoard() {
        textOnBoards[currentPage] = textOnBoard.text
    }
    
    func changeBoard() {
        logoOnBoard.image = logoOnBoards[currentPage]
        titleIntro.text = titleIntros[currentPage]
        textOnBoard.text = textOnBoards[currentPage]
        pageControl.currentPage = currentPage
    }
  
    
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

