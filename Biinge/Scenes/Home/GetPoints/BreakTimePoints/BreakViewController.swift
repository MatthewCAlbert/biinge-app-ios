//
//  BreakViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 11/04/22.
//

import UIKit

class BreakViewController: UIViewController {

    let texts = [
        "Sit in an upright position with neutral shoulders. Rotate the neck clockwise for 10-30 seconds, and vice versa.",
        "Take a grab-able foods like fruit, cut-up veggies, and drink a glass of water!",
        "Let’s strech your body by turning your body to the right and left while doing inhale and exhale.",
        "Close the screen for a while to relax your eyes. Looking at a bright screen for long time can cause eye strain and headache."
    ]
    
    //var
    var a1 : UIImage!
    var a2 : UIImage!
    var a3 : UIImage!
    var a4 : UIImage!
    var a5 : UIImage!
    var a6 : UIImage!
    var a7 : UIImage!
    var a8 : UIImage!
    var a9 : UIImage!
    var a10 : UIImage!
    var a11 : UIImage!
    var a12 : UIImage!
    var a13 : UIImage!
    var a14 : UIImage!
    var a15 : UIImage!
    var a16 : UIImage!
    var a17 : UIImage!
    var a18 : UIImage!
    var a19 : UIImage!
    var a20 : UIImage!
    var a21 : UIImage!
    var a22 : UIImage!
    var a23 : UIImage!
    var a24 : UIImage!
    var a25 : UIImage!
    var a26 : UIImage!
    var a27 : UIImage!
    var a28 : UIImage!
    var a29 : UIImage!
    var a30 : UIImage!
    var a31 : UIImage!
    var a32 : UIImage!
    var a33 : UIImage!
    var a34 : UIImage!
    var a35 : UIImage!
    var a36 : UIImage!
    var a37 : UIImage!
    var a38 : UIImage!
    var a39 : UIImage!
    var a40 : UIImage!
    
    //also var buat images
    var images: [UIImage]!
    
    //buat animated images
    var animatedImage: UIImage!
    
    
    //buat IBOutlet
    @IBOutlet weak var breakTime: UILabel!
    @IBOutlet weak var tipsText: UITextView!
    @IBOutlet weak var earnLbl: UILabel!
    @IBOutlet weak var pointsGet: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var viewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        a1 = UIImage(named: "1.png")
        a2 = UIImage(named: "2.png")
        a3 = UIImage(named: "3.png")
        a4 = UIImage(named: "4.png")
        a5 = UIImage(named: "5.png")
        a6 = UIImage(named: "6.png")
        a7 = UIImage(named: "7.png")
        a8 = UIImage(named: "8.png")
        a9 = UIImage(named: "9.png")
        a10 = UIImage(named: "10.png")
        a11 = UIImage(named: "11.png")
        a12 = UIImage(named: "12.png")
        a13 = UIImage(named: "13.png")
        a14 = UIImage(named: "14.png")
        a15 = UIImage(named: "15.png")
        a16 = UIImage(named: "16.png")
        a17 = UIImage(named: "17.png")
        a18 = UIImage(named: "18.png")
        a19 = UIImage(named: "19.png")
        a20 = UIImage(named: "20.png")
        a21 = UIImage(named: "21.png")
        a22 = UIImage(named: "22.png")
        a23 = UIImage(named: "23.png")
        a24 = UIImage(named: "24.png")
        a25 = UIImage(named: "25.png")
        a26 = UIImage(named: "26.png")
        a27 = UIImage(named: "27.png")
        a28 = UIImage(named: "28.png")
        a29 = UIImage(named: "29.png")
        a30 = UIImage(named: "30.png")
        a31 = UIImage(named: "31.png")
        a32 = UIImage(named: "32.png")
        a33 = UIImage(named: "33.png")
        a34 = UIImage(named: "34.png")
        a35 = UIImage(named: "35.png")
        a36 = UIImage(named: "36.png")
        a37 = UIImage(named: "37.png")
        a38 = UIImage(named: "38.png")
        a39 = UIImage(named: "39.png")
        a40 = UIImage(named: "40.png")
        
        images = [a1, a2, a3, a4, a5, a6, a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40]
        
        animatedImage = UIImage.animatedImage(with: images, duration: 2.0)
        
        viewImage.image = animatedImage 
        // Do any additional setup after loading the view.
        tipsText.text = texts.randomElement()
    }
    

}
