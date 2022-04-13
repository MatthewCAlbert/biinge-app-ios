//
//  SuccessViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 11/04/22.
//

import UIKit

class SuccessViewController: UIViewController {
    
    //randomText
    let texts = [
        "People who took more microbreaks to relax, socialize or engage in cognitive activities had increased positive affect at life.",
        "Make today a productive day by checking what to do next in your agenda! Accomplish your binge-watch target? Done. Accomplish your tasks? Coming right up!",
        "Binge-watching is an easy way to spend time together in strengthen romantic relationships, because it serves as a fun activity in sharing the same interest."
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
    var a41 : UIImage!
    var a42 : UIImage!
    var a43 : UIImage!
    var a44 : UIImage!
    var a45 : UIImage!
    var a46 : UIImage!
    var a47 : UIImage!
    var a48 : UIImage!
    var a49 : UIImage!
    var a50 : UIImage!
    var a51 : UIImage!
    var a52 : UIImage!
    var a53 : UIImage!
    var a54 : UIImage!
    var a55 : UIImage!
    
    //also var buat images
    var images: [UIImage]!
    
    //buat animated images
    var animatedImage: UIImage!
    
    
    //buat IBOutlet
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var congratsText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        a1 = UIImage(named: "s1.png")
        a2 = UIImage(named: "s2.png")
        a3 = UIImage(named: "s3.png")
        a4 = UIImage(named: "s4.png")
        a5 = UIImage(named: "s5.png")
        a6 = UIImage(named: "s6.png")
        a7 = UIImage(named: "s7.png")
        a8 = UIImage(named: "s8.png")
        a9 = UIImage(named: "s9.png")
        a10 = UIImage(named: "s10.png")
        a11 = UIImage(named: "s11.png")
        a12 = UIImage(named: "s12.png")
        a13 = UIImage(named: "s13.png")
        a14 = UIImage(named: "s14.png")
        a15 = UIImage(named: "s15.png")
        a16 = UIImage(named: "s16.png")
        a17 = UIImage(named: "s17.png")
        a18 = UIImage(named: "s18.png")
        a19 = UIImage(named: "s19.png")
        a20 = UIImage(named: "s20.png")
        a21 = UIImage(named: "s21.png")
        a22 = UIImage(named: "s22.png")
        a23 = UIImage(named: "s23.png")
        a24 = UIImage(named: "s24.png")
        a25 = UIImage(named: "s25.png")
        a26 = UIImage(named: "s26.png")
        a27 = UIImage(named: "s27.png")
        a28 = UIImage(named: "s28.png")
        a29 = UIImage(named: "s29.png")
        a30 = UIImage(named: "s30.png")
        a31 = UIImage(named: "s31.png")
        a32 = UIImage(named: "s32.png")
        a33 = UIImage(named: "s33.png")
        a34 = UIImage(named: "s34.png")
        a35 = UIImage(named: "s35.png")
        a36 = UIImage(named: "s36.png")
        a37 = UIImage(named: "s37.png")
        a38 = UIImage(named: "s38.png")
        a39 = UIImage(named: "s39.png")
        a40 = UIImage(named: "s40.png")
        a41 = UIImage(named: "s41.png")
        a42 = UIImage(named: "s42.png")
        a43 = UIImage(named: "s43.png")
        a44 = UIImage(named: "s44.png")
        a45 = UIImage(named: "s45.png")
        a46 = UIImage(named: "s46.png")
        a47 = UIImage(named: "s47.png")
        a48 = UIImage(named: "s48.png")
        a49 = UIImage(named: "s49.png")
        a50 = UIImage(named: "s50.png")
        a51 = UIImage(named: "s51.png")
        a52 = UIImage(named: "s52.png")
        a53 = UIImage(named: "s53.png")
        a54 = UIImage(named: "s54.png")
        a55 = UIImage(named: "s55.png")

        
        images = [a1, a2, a3, a4, a5, a6, a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42,a43,a44,a45,a46,a47,a48,a49,a50,a51,a52,a53,a54,a55]
        
        animatedImage = UIImage.animatedImage(with: images, duration: 3.0)
        
        viewImage.image = animatedImage
        // Do any additional setup after loading the view.
        
        textView.text = texts.randomElement()
        
        congratsText.text = "We appreciate your effort \(UserProfile.shared.username ?? "Watcher")!🥳"
    }
}
